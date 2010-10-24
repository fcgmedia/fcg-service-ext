Dir[
  File.expand_path("../plugins/*_module.rb", __FILE__),
  File.expand_path("../plugins/*_plugin.rb", __FILE__),
].each do |file|
  require file
end