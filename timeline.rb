require_relative './project.rb'

class LinearExecutionTimeline
  def self.from_project_list(projects)
    initialize_start_times(projects)
    ticks = bucket_the_work(projects)
    initialize_leads_and_lags(projects, ticks)

    new ticks
  end

  def self.initialize_start_times projects
    projects.first.start_date = 0
    projects.each_cons(2) do |p1, p2|
      p2.start_date = p1.end_date
    end
  end

  def self.enumerate_day_items(projects)
    Enumerator.new do |y|
      projects.each do |p|
        item = DayItem.new(p.name,  p)
        p.days.times do |n|
          y << item
        end
      end
    end
  end

  def self.bucket_the_work(projects)
    enumerate_day_items(projects)
      .map { |item| [item] }
  end

  def self.initialize_leads_and_lags(projects, ticks)
    projects.each do |project|
      project.leads_and_lags.each do |date, item|
        ticks[date] ||= [] # necessary for the very last lag
        ticks[date] << item
      end
    end
  end

  attr_reader :ticks
  def initialize ticks
    @ticks = ticks
  end
end
