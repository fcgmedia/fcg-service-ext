module SocialPlugin
  module ClassMethods
    def find_by_facebook_id(fb_id)
      where(:facebook_id => fb_id).first
    end
  end
  
  def self.configure(model)
    # puts "Configuring SocialPlugin for #{model}..."
    model.field :facebook_session, :type => Hash
    model.field :facebook_id, :type => String
    model.field :facebook_proxy_email, :type => String
    model.field :twitter_username, :type => String
  end
  
  def self.included(receiver)
    receiver.send :include, SocialModule
    self.configure(receiver)
  end
end