module FCG
  module CookieHelper
    module InstanceMethods
      protected
      def set_user_cookie(value, app_name=nil, env=nil)
        load_user_cookie_for(app_name, env) if @user_cookie.nil?
        @user_cookie = {
          :value => value,
          :path => "/"
        }
      end

      def erase_user_cookie
        @user_cookie = nil
      end
      
      def valid_user_cookie?(secret)
        @user_cookie["signature"] == Base64.encode64(HMAC::SHA1.digest(secret, "#{@user_cookie['expires']}\n#{@user_cookie['user_sig']}")).chomp
      end
      
      def load_user_cookie_for(app_name, env=nil)
        @user_cookie ||= begin
          value = if env.nil?
            cookies[user_cookie_name(app_name)]
          else
            Rack::Request.new(env).cookies[user_cookie_name(app_name)]
          end
          JSON.parse(value)
        end
      end
      
      def user_cookie_for(app_name)
        @user_cookie
      end
      
      def user_cookie_name(app_name)
        app_name + "_user"
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
  end
end