module UserHashPlugin
  def self.configure(model)
    # puts "Configuring UserHashPlugin for #{model}..."
    model.field :names, :type => Hash
    model.field :site_specific_settings, :type => Hash
    model.field :location, :type => Hash #city, state, zipcode, country, time_zone
    model.field :flags, :type => Hash
  end
  
  def self.included(receiver)
    receiver.send :include, UserHashModule
    self.configure(receiver)
  end
end