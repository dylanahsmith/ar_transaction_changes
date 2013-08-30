require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'
require 'appraisal'

task :default => 'test'

Rake::TestTask.new(:test) do |t|
  t.libs << '.' << 'lib' << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
end
