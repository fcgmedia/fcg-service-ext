# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fcg-service-ext}
  s.version = "0.0.16"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Samuel O. Obukwelu"]
  s.date = %q{2011-02-07}
  s.description = %q{An extension for FCG Services}
  s.email = %q{sam@fcgmedia.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "fcg-service-ext.gemspec",
     "lib/fcg-service-ext.rb",
     "lib/fcg-service-ext/fcg.rb",
     "lib/fcg-service-ext/helpers/authentication.rb",
     "lib/fcg-service-ext/helpers/cookie_helper.rb",
     "lib/fcg-service-ext/helpers/inflections.rb",
     "lib/fcg-service-ext/helpers/session_controller_helper.rb",
     "lib/fcg-service-ext/models/user_includable.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/image_plugin.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/rating_plugin.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/social_module.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/social_plugin.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/token_module.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/token_plugin.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/user_hash_module.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/user_hash_plugin.rb",
     "lib/fcg-service-ext/mongo_mapper/plugins/voting_plugin.rb",
     "lib/fcg-service-ext/version.rb",
     "spec/fcg-service-ext_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/joemocha/fcg-service-ext}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{FCG Service Extensions}
  s.test_files = [
    "spec/fcg-service-ext_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_runtime_dependency(%q<guid>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_dependency(%q<guid>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<mongo_mapper>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<ruby-hmac>, [">= 0"])
    s.add_dependency(%q<guid>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end

