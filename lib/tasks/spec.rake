require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'

REPORT_PATH = "spec/reports"

RSpec::Core::RakeTask.new(:spec)

task :setup do
  rm_rf REPORT_PATH
  mkdir_p REPORT_PATH
end

task :spec => [:setup, 'ci:setup:rspec']


