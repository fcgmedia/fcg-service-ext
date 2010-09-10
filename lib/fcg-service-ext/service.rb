require 'sinatra' unless defined?(Sinatra)
module Service
  include ClassLevelInheritableAttributes
  cattr_inheritable :model, :api_version
  class Base < Sinatra::Base
    disable :layout
    before do
      content_type :json
    end

    get "/service" do
      "You are using #{self.class} at #{Time.now.utc}".to_json
    end
    
    def error_hash(instance, message)
      errors = instance.errors.inject({}) do |sum,values| 
        k = values.shift
        sum[k] = values.map(&:uniq)
        sum
      end
      {
        :message => message,
        :errors => errors
      }
    end
  end
end