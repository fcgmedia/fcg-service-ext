module TokenPlugin
  module ClassMethods
    def find_by_token(token)
      where(:token_id => token).first
    end
  end
  
  def self.configure(model)
    # puts "Configuring TokenPlugin for #{model}..."
    model.key :token_id, String
    model.key :token_expire_at, Time
  end

  def self.included(receiver)
    receiver.send :include, TokenModule
  end
end