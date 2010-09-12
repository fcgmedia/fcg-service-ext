require 'rubygems'
require 'rake'
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
    gem.add_development_dependency "rspec", ">= 1.2.9"
    
    gem.add_dependency("json")
    gem.add_dependency("yajl-ruby")
    gem.add_dependency("ruby-hmac")
    gem.add_dependency('guid')
    gem.add_dependency('bson', ">= 1.0.7")
    gem.add_dependency('bson_ext', ">= 1.0.7")
    gem.add_dependency('mongo_mapper', ">= 0.8.4")
    gem.add_dependency('sinatra')
    gem.add_dependency('activesupport', ">= 3.0.0")
    gem.add_dependency('activemodel', ">= 3.0.0")
    gem.add_dependency('typhoeus', ">= 0.1.31")
    
    gem.version = FcgServiceExt::VERSION
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
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
