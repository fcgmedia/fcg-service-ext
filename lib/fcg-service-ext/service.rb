require 'sinatra' unless defined?(Sinatra)
module Service
  class Base < Sinatra::Base
    disable :layout
    before do
      content_type :json
    end

    get "/service" do
      "You are using #{self.class} at #{Time.now.utc}".to_json
    end
    
    def error_hash(instance, message)
      {
        :message => message,
        :errors => instance.errors
      }
    end
  end
end