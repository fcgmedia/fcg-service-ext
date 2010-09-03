require 'sinatra' unless defined?(Sinatra)
module Service
  class Base < Sinatra::Base
    before do
      content_type :json
    end

    get "/service" do
      "You are using #{self.class} at #{Time.now.utc}".to_json
    end
  end
end