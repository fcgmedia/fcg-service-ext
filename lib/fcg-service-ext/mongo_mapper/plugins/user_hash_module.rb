module UserHashModule
  module InstanceMethods
    [:first, :last].each do |name|
      define_method("#{name}_name=") do |val|
        names[name] = val
      end

      define_method("#{name}_name") do
        names[name]
      end
    end

    def full_name
      [first_name, last_name].compact.join(" ").strip
    end

    [:enabled, :confirmed, :keep_profile_private].each do |f|
      define_method("#{f}=") do |val|
        flags[f] = !!val
      end

      define_method(f) do
        flags[f].nil? ? nil : !!flags[f] 
      end

      define_method("#{f}?") do
        flags[f]
      end
    end

    [:city, :state, :zipcode, :country, :time_zone].each do |loc|
      define_method("#{loc}=") do |val|
        location[loc] = val
      end

      define_method(loc) do
        location[loc]
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end