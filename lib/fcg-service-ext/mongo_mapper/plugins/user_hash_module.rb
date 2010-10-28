module UserHashModule
  module InstanceMethods
    def full_name
      [first_name, last_name].compact.join(" ").strip
    end

    [:enabled, :confirmed, :keep_profile_private].each do |f|
      define_method("#{f}=") do |val|
        flags[f] = case val
        when true, "true", 1, "1"
          true
        else
          false
        end
      end

      define_method(f) do
        flags[f].nil? ? nil : !!flags[f] 
      end

      define_method("#{f}?") do
        flags[f]
      end

      define_method("#{f}!") do
        flags[f] = true
        save
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