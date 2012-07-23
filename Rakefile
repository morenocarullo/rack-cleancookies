$:.unshift File.join(File.dirname(__FILE__), 'lib')

gem 'bundler'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/unit/*_test.rb']
end

task :default => [:test]
