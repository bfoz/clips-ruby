require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test).tap do |task|
    task.pattern = 'test/**{,/*/**}/*.rb'
end

task :default => :test
