require "rubygems"
require "json"
require "ruby_hmac"
require "hmac-sha1"

module FCG
  module SessionControllerHelper
    module InstanceMethods
      def create_user_cookie(*args)
        options = args.extract_options!
        opts = {
          :time => Time.now,
          :secret => "S9vtS#wPFP'xX=AcLi-B,I#JEjh5h(~RgmZ<XXsi'Ufac<$x8q%._owOtJ>A7'D",
          :app_name => "FCG",
          :user_hash => {}
        }.merge(options)
        expires = opts[:time].to_i + (60*60*2)
        user_sig = Base64.encode64(HMAC::SHA1.digest(opts[:secret], JSON.generate(opts[:user_hash]))).chomp
        signature = Base64.encode64(HMAC::SHA1.digest(opts[:secret], "#{expires}\n#{user_sig}")).chomp

        value = JSON.generate({
          :user => opts[:user_hash],
          :user_sig => user_sig,
          :expires => expires,
          :signature => signature
        })

        cookies["#{opts[:app_name]}_user"] = {
          :value => value,
          :path => "/"
        }
      end

      def erase_user_cookie(app_name)
        cookies["#{app_name}_user"] = nil
      end

      def get_hmac_signature(secret, params)
        signature = CGI::unescape(Base64.encode64(HMAC::SHA1.digest(secret, "#{params[:expires]}\n#{params[:return_to]}\n#{params[:user_id]}")).chomp)
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
  end
end