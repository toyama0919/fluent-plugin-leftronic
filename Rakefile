require "bundler"
require "bundler/gem_tasks"
Bundler::GemHelper.install_tasks
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/plugin/*.rb']
  test.verbose = true
end

task :coverage do |t|
  ENV['COVERAGE'] = '1'
  Rake::Task["test"].invoke
end

task :default => [:build]