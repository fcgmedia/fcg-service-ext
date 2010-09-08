module TokenPlugin
  module ClassMethods
    def find_by_token(token)
      where(:token_id => token).first
    end
  end
  
  module InstanceMethods
    def token_expires_in(time=5.mins)
      token_expire_at = time.from_now.utc
    end

    def generate_token!(expires_at=1.day.since)
      self.token_id = "#{Time.now.utc.to_i}-#{Guid.new}"
      self.token_expire_at = expires_at.utc
      save!
    end
  end
  
  def self.configure(model)
    # puts "Configuring TokenPlugin for #{model}..."
    model.key :token_id, String
    model.key :token_expire_at, Time
  end
end