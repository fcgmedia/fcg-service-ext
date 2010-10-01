module RatingPlugin
  def self.included(receiver)
    receiver.field :rating, :type => Float, :default => 0.0
  end
end