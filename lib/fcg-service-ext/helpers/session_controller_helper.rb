require "json"
require "digest/sha1"
module SessionControllerHelper
  module InstanceMethods

    def create_user_cookie
      expires = Time.now.to_i + (60*60*2)
      user_sig = Base64.encode64(HMAC::SHA1.digest(FCG_CONFIG[:app][:auth_secret], JSON.generate(self.current_user.user_info))).chomp
      signature = Base64.encode64(HMAC::SHA1.digest(FCG_CONFIG[:app][:auth_secret], "#{expires}\n#{user_sig}")).chomp

      value = {
        :user => self.current_user.user_info,
        :user_sig => user_sig,
        :expires => expires,
        :signature => signature
      }

      cookies["#{FCG_CONFIG[:app][:name]}_user"] = {
        :value => JSON.generate(value),
        :path => "/"
      }
    end

    def erase_user_cookie
      cookies["#{FCG_CONFIG[:app][:name]}_user"] = nil
    end
    
    def get_hmac_signature(secret, params)
      signature = CGI::unescape(Base64.encode64(HMAC::SHA1.digest(secret, "#{params[:expires]}\n#{params[:return_to]}\n#{params[:user_id]}")).chomp)
    end
  end
  
  def self.included(receiver)
    raise "FCG_CONFIG is missing" unless FCG_CONFIG
    receiver.send :include, InstanceMethods
  end
end