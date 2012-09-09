# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rake/testtask'

desc "Default Task"
task :default => :test

desc "Run all tests"
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

namespace :test do

  Rake::TestTask.new(:integration) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/integration/*_test.rb'
    t.verbose = false
  end

  Rake::TestTask.new(:module) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/module/*_test.rb'
    t.verbose = false
  end

end
