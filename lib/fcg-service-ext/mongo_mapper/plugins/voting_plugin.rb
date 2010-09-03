module VotingPlugin
  module ClassMethods
  end
  
  module InstanceMethods
    def upvote(user_id)
      self.class.collection.update(
        {"_id" => self.id, 'up_voters' => {'$ne' => user_id} }, 
        {"$push" => {"up_voters" => user_id }, "$inc" => {"up_votes" => 1, "net_votes" => 1 } }
      )
    end
    
    def downvote(user_id)
    self.class.collection.update(
      { "_id" => self.id, 'down_voters' => {'$ne' => user_id} }, 
      { "$push" => {"down_voters" => user_id }, "$inc" => {"down_votes" => 1, "net_votes" => -1 } }
    )
    end
    
    private
    # model owner automatically upvotes.
    def auto_upvote
      upvote(self.user_id) if self.user_id?
    end
  end
  
  def self.configure(model)
    puts "Configuring VotingPlugin for #{model}..."
    model.key :up_voters,     Array
    model.key :up_votes,      Integer, :default => 0
    model.key :down_voters,   Array
    model.key :down_votes,    Integer, :default => 0
    model.key :net_votes,     Integer, :default => 0
    
    model.after_create :auto_upvote if model.respond_to? :after_create
  end
end