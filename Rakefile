#!/usr/bin/env rake
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'

task :default => :spec

spec = eval(File.read('clot_engine.gemspec'))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
end

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end



