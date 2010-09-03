require 'mongo_mapper'

Dir[
  File.expand_path("plugins/*.rb", __FILE__)
].each do |file|
  require file
end