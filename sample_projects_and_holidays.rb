def load_projects
  [
    Project.new("Widget A", 4),
    Project.new("Widget B", 5, leads: { 'design complete': 4, 'dev ready': 2}),
    Project.new("Redesign the website", 12, leads: { 'design complete': 6, 'dev ready': 2}),
    Project.new("Widget Q", 5, leads: { 'design complete': 6, 'dev ready': 2}),
    Project.new("Widget C", 7, leads: { 'design complete': 4, 'dev ready': 1}),
  ]
end

def load_holidays
  [
    date_range('2017-12-14', '2017-12-15'), # holiday party
    date_range('2017-12-22', '2018-01-02'), # holiday code freeze
  ]
end
