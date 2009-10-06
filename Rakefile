require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :spec

require 'rake'
require 'spec/rake/spectask'

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/*.rb']
  t.fail_on_error = false
end

desc 'Generate documentation for the has_default plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HasDefault'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "has_default"
    gemspec.summary = "Specify a default instance to be returned for an ActiveRecord model"
    gemspec.description = ""
    gemspec.email = "brad@conden.se"
    gemspec.homepage = "http://github.com/bradgessler/has_default"
    gemspec.authors = ["Brad Gessler"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end