require 'rubygems'
require "bundler/setup"
# require 'json'
# require 'yajl/json_gem'
# require 'ruby_hmac'
# require 'hmac-sha1'
# require 'active_model'
# require 'active_support'
Bundler.setup
Bundler.require(:default)
require 'fcg-service-ext/version'
%W{
  fcg
  mongo_mapper/plugins
}.each do |file|
  require "fcg-service-ext/#{file}"
end

# models, helpers
Dir[
  File.expand_path("../fcg-service-ext/models/*.rb", __FILE__),
  File.expand_path("../fcg-service-ext/helpers/*.rb", __FILE__)
].each do |file|
  require file
end