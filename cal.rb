require 'date'
require 'pry'
require 'set'
require_relative './timeline.rb'

module DateAdditions
  refine Date do
    def weekend?
      saturday? || sunday?
    end
  end
end

def date_range(start, finish)
  Range.new(Date.parse(start), Date.parse(finish))
end

class Week
  attr_reader :date_items_tuples
  def initialize date_items_tuples
    @date_items_tuples = date_items_tuples
  end

  def first_day
    date_items_tuples.first.first
  end

  def title
    "Week of #{first_day}"
  end

  def inverted
    date_items_tuples.reduce(Hash.new { |hash, key| hash[key] = [] }) do |acc, day|
      next acc unless day.last
      day.last.each do |item|
        acc[item] << day.first
      end

      acc
    end
  end

  def include? project
    inverted.keys.any? { |item| item.project == project }
  end

  def label_for(project)
    inverted.keys.select { |item| item.project == project }.map { |item| item.label }.uniq
  end
end

class Calendar
  attr_reader :ticks, :dates
  def initialize(ticks, dates)
    @ticks, @dates = ticks, dates
  end

  def dated_ticks
    dates
      .lazy
      .zip(ticks)
      .take(ticks.size)
      .to_h
  end

  def group_by_week
    dated_ticks
      .group_by { |date, items| date&.cweek }
      .map { |cweek, contents| contents }
      .map do |dates_in_week|
        Week.new dates_in_week
      end
  end

  def print_by_week
      group_by_week.each do |week|
        puts week.title
        week.inverted.each do |item, days|
          puts " - #{item.to_s(days)}"
        end
      end
  end
end

class Plotter
  using DateAdditions
  def self.working_days(start, exclude=[])
    Enumerator.new do |y|
      candidate = start
      loop do
        unless candidate.weekend? || exclude.any? { |d| d === candidate }
          y << candidate
        end
        candidate = candidate.succ
      end
    end
  end

  attr_reader :projects, :timeline, :holidays, :start_date
  def initialize(projects, execution_model, holidays, start_date)
    @projects = projects
    @timeline = execution_model.from_project_list(projects)
    @holidays = holidays
    @start_date = start_date
  end

  def calendar
    @cal ||= Calendar.new(timeline.ticks, self.class.working_days(start_date, holidays))
  end

  def print_by_week
    calendar.print_by_week
  end

  def print_by_project
    projects_col = projects.map(&:name)
    weeks = calendar.group_by_week
    puts ['Projects'].concat(weeks.map(&:first_day)).join(', ')
    projects.each do |p|
      puts [p.name].concat(weeks.map do |week|
        if week.include? p
          week.label_for(p).join('|')
        else
          'off'
        end
      end).join(', ')
    end
  end
end

config_file = ARGV[0] || 'projects_and_holidays.rb'
unless File.exists?(config_file)
  puts "Usage: #{$0} [projects-and-holidays-file]"
  puts "  Default file is projects_and_holidays.rb"
  puts "  It must define load_projects and load_holidays"
  exit 1
end

load config_file
projects = load_projects
holidays = load_holidays
start_date = Date.parse('2017-12-13')

plotter = Plotter.new(projects, LinearExecutionTimeline, holidays, start_date)
plotter.print_by_project if ARGV.include? '--gantt'
plotter.print_by_week if ARGV.include? '--weekly'
