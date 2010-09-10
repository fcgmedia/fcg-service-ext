module FCG
  module UserIncludable
    module ClassMethods
      
    end
    
    module InstanceMethods
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :include, UserHashModule
      receiver.send :include, TokenModule
      receiver.send :include, SocialModule
    end
  end
end