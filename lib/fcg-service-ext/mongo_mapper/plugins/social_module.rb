module SocialModule
  module ClassMethods
    def find_by_facebook_id(fb_id)
      where(:facebook_id => fb_id).first
    end
    
    def get_data_from_facebook_session(access_token)
      MiniFB::OAuthSession.new(access_token)
    end
    
    def create_using_facebook_oauth(username, access_token)
      user = nil
      returning get_data_from_facebook_session(access_token) do |fb|
        password = generate_challenge(6)
        user = new(
          :username               => username,
          :email                  => fb.me.email,
          :facebook_proxy_email   => fb.me.email,
          :facebook_id            => fb.me.id,
          :password               => password,
          :password_confirmation  => password
        )
        user.confirm! if user.valid?
      end
      user
    end
  end
  
  module InstanceMethods
    def has_facebook?
      !self.facebook_id.nil? and self.facebook_id != ""
    end
  
    def has_twitter?
      !self.twitter_username.nil? and self.twitter_username != ""
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end