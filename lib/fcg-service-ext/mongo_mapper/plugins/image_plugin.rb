# encoding: UTF-8
module ImagePlugin
  module ClassMethods
    def image_keys(*keys)
      keys.each do |k|
        ks = k.to_s.pluralize.to_sym
        album = "#{k}_album".to_sym
        counter = "#{k}_album.count".to_sym
        
        key ks,            Array,   :typecast => 'ObjectId'
        key album,         Hash
        scope "has_#{ks}".to_sym, where(counter.gt => 0)
        
        create_image_keys_instance_methods(k)
        
        [ks, album].each{|e| image_key_array << e }
      end
      attr_accessor :album_hash
      puts "ImagePlugin instance methods: " + @image_keys.inspect
    end
    
    def image_key_array
      @image_keys ||= []
    end
    
    private
    def create_image_keys_instance_methods(el)
      els = el.to_s.pluralize
      
      define_method("reset_#{el}_order!".to_sym) do
        order = self.send(els.to_sym).map(&:to_s)
        new_order = order.join(",")
        self.class.collection.update({"_id" => self.id}, {
          '$set' =>  { "#{el}_album.order" => new_order, "#{el}_album.count" => order.size },
        })
      end
      
      define_method("add_#{el}!") do |img|
        order = self.send("#{el}_album".to_sym)[:order] || ""
        order << "," if order.length > 0
        order << img.id.to_s
        self.class.collection.update({"_id" => self.id}, {
          '$set' =>  { "#{el}_album.order" => order }, 
          '$inc' =>  { "#{el}_album.count" => 1 }, 
          '$push' => { "#{el}s" => img.id } 
        })
      end
      
      define_method("drop_#{el}!") do |img|
        order = self.send("#{el}_album".to_sym)[:order] || ""
        if order.respond_to? :split
          order = order.split(/,/)
        end
        new_order = order.reject{|o| o == img.id.to_s }
        new_order_as_string = new_order.join(",")
        self.class.collection.update({"_id" => self.id}, {
          '$set' =>  { "#{el}_album.order" => new_order_as_string }, 
          '$inc' =>  { "#{el}_album.count" => -1 }, 
          '$pull' => { "#{el}s" => img.id }
        })
      end

      define_method("#{els}_instantiated") do
        obj_ids = self.send(els.to_sym).map{|id| id.to_s }
        images = Image.find(obj_ids)
        hash = {
          :images_by_key => ActiveSupport::OrderedHash.new,
          :images_sorted_by_id => self.send("#{el}_album".to_sym)[:order] || ""
        }
        images.inject(hash[:images_by_key]) do |sum, img|
          sum[img.id.to_s] = img
          sum
        end
        hash
      end
      
      define_method("#{els}_sorted") do
        images_sorted_by_id = self.send("#{el}_album".to_sym)[:order]
        ids = self.send(els.to_sym).map{|id| id.to_s }
        [images_sorted_by_id.split(/,/), ids].flatten.uniq
      end
      
      ["update_#{el}_album", "add_#{el}!", "drop_#{el}!", "#{els}_instantiated", "#{els}_sorted", "reset_#{el}_order!"].each{|e| image_key_array << e.to_sym }
    end
  end
  
  module InstanceMethods
    def update_album(album_name, album_hash)
      # update_attributes "#{album_name.to_s.singularize}_album".to_sym => album_hash
      name_proc = Proc.new{|name| "#{album_name.to_s.singularize}_album.#{name}" }
      new_album_hash = album_hash.inject({}) do |rec, (key, value)|
        rec[name_proc.call(key)] = value
        rec
      end
      self.class.collection.update({"_id" => self.id}, {
        '$set' => new_album_hash
      })
    end
    
    def image_method(*args)
      meth = args.first
      options = args.last.is_a?(Hash) ? args.pop : {}
      meth = meth.to_sym unless meth.is_a? Symbol
      if self.class.image_key_array.include?(meth)
        begin
          send(meth)
        rescue ArgumentError
          send(meth, options)
        end
      end
    end
  end
  
  def self.configure(model)
    puts "Configuring ImagePlugin for #{model}..."
  end
end