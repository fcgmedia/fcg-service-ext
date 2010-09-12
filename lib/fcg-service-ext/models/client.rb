require "rubygems"
require "active_model"
require "active_support"
require "typhoeus"

Dir[
  File.expand_path("../../cattr_inheritable_attrs.rb", __FILE__)
].each do |file|
  require file
end

module FCG
  module Client
    module ClassMethods
      def find(id)
        request = Typhoeus::Request.new(
          "#{self.host}/api/#{self.version}/#{self.model}/#{id}",
          :method => :get)
        request.on_complete do |response|
          handle_service_response(response)
        end

        self.hydra.queue(request)
        self.hydra.run

        request.handled_response
      end

      def handle_service_response(response)
        case response.code
        when 200
          new(JSON.parse(response.body))
        when 400
          {
            :error => {
              :http_code => response.code,
              :http_response_body => JSON.parse(response.body)
            }
          }
          false
        end
      end

      def setup_service(*args)
        args.each do |arg| 
          arg.each_pair do |key, value| 
            class_eval{ instance_variable_set("@#{key}", value) }
          end 
        end
        class_eval do
          instance_variable_set("@model", self.name.downcase.pluralize) if instance_variable_get("@model").nil?
        end
      end
      
      def attributes
        @attributes ||= const_get('ATTRIBUTES' )
      end
    end

    module InstanceMethods
      def initialize(attributes_or_json = {})
        from_json(attributes_or_json) if attributes_or_json.is_a? String
        self.attributes = attributes_or_json.respond_to?(:with_indifferent_access) ? attributes_or_json.with_indifferent_access : attributes_or_json
        @errors = ActiveModel::Errors.new(self)
        @new_record = (self.id.nil? ? true :false)
        self
      end

      def attributes
        self.class.attributes.inject(ActiveSupport::HashWithIndifferentAccess.new) do |result, key|
          result[key] = read_attribute_for_validation(key)
          result
        end
      end

      def attributes=(attrs)
        attrs.each_pair {|name, value| send("#{name}=", value)}
      end

      def read_attribute_for_validation(key)
        send(key)
      end

      def save(*)
        create_or_update
      end

      def new_record?
        @new_record
      end

      def errors
        @errors ||= ActiveModel::Errors.new(self)
      end

      private
      def handle_service_response(response)
        case response.code
        when 200
          attributes_as_json = JSON.parse(response.body)
          self.attributes = attributes_as_json.respond_to?(:with_indifferent_access) ? attributes_as_json.with_indifferent_access : attributes_as_json
          true
        when 400
          response_body_parsed = JSON.parse(response.body)
          response_body_parsed["errors"].each_pair do |key, values|
            values.compact.each{|value| errors.add(key.to_sym, value) }
          end
          false
        end
      end

      def create
        return false unless valid?
        Typhoeus::Request.new(
          "#{self.class.host}/api/#{self.class.version}/#{self.class.model}",
          :method => :post, :body => self.to_json)
      end

      def update
        return false unless valid?
        Typhoeus::Request.new(
          "#{self.class.host}/api/#{self.class.version}/#{self.class.model}/#{self.id}",
          :method => :put, :body => self.to_json)
      end

      def create_or_update
        request = new_record? ? create : update
        if request.respond_to? :on_complete
          request.on_complete do |response|
            return handle_service_response(response)
          end

          self.class.hydra.queue(request)
          self.class.hydra.run

          request.handled_response
        else
          request != false
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      # receiver.send :include, ActiveModel::Validations
      receiver.send :include, ActiveModel::Serializers::JSON
      receiver.send :include, ClassLevelInheritableAttributes
      receiver.cattr_inheritable :host, :hydra, :model, :version, :async_client
    end
  end
end
__END__
HYDRA = Typhoeus::Hydra.new

class Run
  ATTRIBUTES = [:id, :bio, :created_at, :crypted_password, :date_of_birth, :deleted_at, :email, 
    :facebook_id, :facebook_proxy_email, :facebook_session, :flags, :flyers, :last_visited_at, 
    :location, :names, :password, :photo_album, :photo_count, :photos, :posted_party_at, :profile_image, 
    :salt, :sex, :site_specific_settings, :token_expire_at, :token_id, :tokens_expire_at, 
    :twitter_username, :updated_at, :uploaded_photos_at, :username, :web]
  attr_accessor *ATTRIBUTES
  include FCG::Client
  setup_service :model => "users", :hydra => HYDRA, :host => "http://127.0.0.1:8081", :version => "v1"
end

1.upto(6).each do |i|
  puts "Pass ##{i}"
  t = Run.find("4c401627ff808d982a00000b")
  puts t.inspect
end