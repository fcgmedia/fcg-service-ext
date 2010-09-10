module UserHashPlugin
  def self.configure(model)
    # puts "Configuring UserHashPlugin for #{model}..."
    model.key :names, Hash
    model.key :site_specific_settings, Hash
    model.key :location, Hash #city, state, zipcode, country, time_zone
    model.key :flags, Hash
  end
  
  def self.included(receiver)
    receiver.send :include, UserHashModule
  end
end