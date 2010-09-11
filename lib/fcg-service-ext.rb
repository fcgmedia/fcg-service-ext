require 'fcg-service-ext/version'
%W{
  cattr_inheritable_attrs
  service
  mongo_mapper/plugins
  models
}.each do |filename|
  require "fcg-service-ext/#{filename}"
end
# Dir[
#   File.expand_path("../models/*.rb", __FILE__)
# ].each do |file|
#   require file
# end
# require 'fcg-service-ext/cattr_inheritable_attrs'
# require 'fcg-service-ext/service'
# require 'fcg-service-ext/mongo_mapper/plugins'
# require 'fcg-service-ext/models'