module TokenPlugin
  module ClassMethods
    def find_by_token(token)
      where(:token_id => token).first
    end
  end
  
  def self.configure(model)
    # puts "Configuring TokenPlugin for #{model}..."
    model.field :token_id, :type => String
    model.field :token_expire_at, :type => Time
  end

  def self.included(receiver)
    receiver.send :include, TokenModule
    self.configure(receiver)
  end
end