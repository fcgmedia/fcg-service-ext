module UserHashPlugin
  def self.configure(model)
    # puts "Configuring UserHashPlugin for #{model}..."
    model.field :names, :type => Hash, :default => {}
    model.field :site_setting, :type => Hash, :default => {}
    model.field :location, :type => Hash, :default => {}  #city, state, zipcode, country, time_zone
    model.field :flags, :type => Hash, :default => {}
  end
  
  def self.included(receiver)
    receiver.send :include, UserHashModule
    self.configure(receiver)
  end
end