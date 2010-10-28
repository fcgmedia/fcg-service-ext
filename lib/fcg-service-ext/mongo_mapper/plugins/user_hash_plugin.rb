module UserHashPlugin
  def self.configure(model)
    # puts "Configuring UserHashPlugin for #{model}..."
    model.field :first_name,    :type => String
    model.field :last_name,     :type => String
    model.field :site_setting,  :type => Hash
    model.field :location,      :type => Hash  #city, state, zipcode, country, time_zone
    model.field :flags,         :type => Hash
  end
  
  def self.included(receiver)
    receiver.send :include, UserHashModule
    self.configure(receiver)
  end
end