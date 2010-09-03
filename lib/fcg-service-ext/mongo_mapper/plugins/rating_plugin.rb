module RatingPlugin
  def self.configure(model)
    puts "Configuring RatingPlugin for #{model}..."
    model.key :rating, Float, :default => 0.0
  end
end