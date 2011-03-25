module FCG
  module SessionControllerHelper
    module InstanceMethods
      protected
      def create_user_cookie(*args)
        options = args.extract_options!
        opts = {
          :time => Time.now.utc,
          :secret => "S9vtS#wPFP'xX=AcLi-B,I#JEjh5h(~RgmZ<XXsi'Ufac<$x8q%._owOtJ>A7'D",
          :app_name => "FCG",
          :user_info => {},
          :env => nil
        }.merge(options)
        expires = opts[:time].to_i + (60*60*2)
        user_sig = Base64.encode64(HMAC::SHA1.digest(opts[:secret], JSON.generate(opts[:user_info]))).chomp
        signature = Base64.encode64(HMAC::SHA1.digest(opts[:secret], "#{expires}\n#{user_sig}")).chomp

        value = JSON.generate({
          :user_info => opts[:user_info],
          :user_sig => user_sig,
          :expires => expires,
          :signature => signature
        })
        
        set_user_cookie(value, opts[:app_name], opts[:env])
      end
      
      def get_hmac_auth_signature(secret, params)
        CGI::unescape(Base64.encode64(HMAC::SHA1.digest(secret, "#{params[:expires]}\n#{params[:return_to]}\n#{params[:user_id]}")).chomp)
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
      receiver.send :include, FCG::CookieHelper
    end
  end
end