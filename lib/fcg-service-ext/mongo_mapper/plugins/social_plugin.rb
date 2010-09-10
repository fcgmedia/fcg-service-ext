module SocialPlugin
  
  def self.configure(model)
    # puts "Configuring SocialPlugin for #{model}..."
    model.key :facebook_session, Hash
    model.key :facebook_id, String
    model.key :facebook_proxy_email, String
    model.key :twitter_username, String
  end
  
  def self.included(receiver)
    receiver.send :include, SocialModule
  end
end