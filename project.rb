class Project
  attr_accessor :start_date
  attr_reader :name, :days, :leads

  def initialize(name, days, leads:{})
    @name, @days, @leads = name, days, leads
  end

  def lags
    {
      'launched': [2, (0.3*days).to_i].max,
    }
  end

  def end_date
    start_date + days
  end

  def leads_and_lags
    Enumerator.new do |y|
      leads.each do |desc, value|
        tick = [start_date - value, 0].max
        y << [tick, DeadlineItem.new("#{name} needs to be #{desc}", self, tick, desc)]
      end

      lags.each do |desc, value|
        tick = end_date + value
        y << [tick, DeadlineItem.new("#{name} should be #{desc}", self, tick, desc)]
      end
    end
  end
end

class DayItem
  attr_reader :name, :project

  def initialize name, project
    @name, @project = name, project
  end

  def to_s(days)
    "#{name} (#{days.size}d)"
  end

  def label
    'dev'
  end
end

class DeadlineItem
  attr_reader :name, :project, :date, :label

  def initialize name, project, date, label
    @name, @project, @date = name, project, date
    @label = label
  end

  def to_s(days)
    day = days.first
    "#{name} on #{day}"
  end
end

