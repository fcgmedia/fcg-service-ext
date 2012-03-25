require 'rubygems'
require 'rake'

$LOAD_PATH.unshift File.dirname(File.expand_path(__FILE__))
require 'lib/fcg-service-ext/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fcg-service-ext"
    gem.summary = 'FCG Service Extensions'
    gem.description = 'An extension for FCG Services'
    gem.email = "sam@fcgmedia.com"
    gem.homepage = "http://github.com/joemocha/fcg-service-ext"
    gem.authors = ["Samuel O. Obukwelu"]
    gem.add_development_dependency "rspec", ">= 2.0"
    gem.add_dependency 'activesupport'
    gem.add_dependency 'mongo_mapper'
    gem.add_dependency 'i18n'
    gem.add_dependency 'json'
    gem.add_dependency 'yajl-ruby'
    gem.add_dependency 'ruby-hmac'
    gem.add_dependency 'guid'

    gem.version = FcgServiceExt::VERSION
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov_opts =  %q[--exclude "spec"]
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fcg-service-ext #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
