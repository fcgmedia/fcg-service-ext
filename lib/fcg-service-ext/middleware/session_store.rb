require 'rack/session/abstract/id'
require 'securerandom'

# Backporting from Rack trunk, current version(1.2.1) doesn't have ssl? helper and it's 'scheme' method is too naive.
module Rack
  class Request

    def scheme
      if @env['HTTPS'] == 'on'
        'https'
      elsif @env['HTTP_X_FORWARDED_SSL'] == 'on'
        'https'
      elsif @env['HTTP_X_FORWARDED_PROTO']
        @env['HTTP_X_FORWARDED_PROTO'].split(',')[0]
      else
        @env["rack.url_scheme"]
      end
    end

    def ssl?
      scheme == 'https'
    end

    alias :secure? :ssl?
  end
end

module Rack
  module Session

    # The Abstract::ID quite differs between versions, I decided to not rely on it.
    class FCGStore # < Abstract::ID

      attr_reader :mutex, :pool, :key, :options

      DEFAULT_OPTIONS = Abstract::ID::DEFAULT_OPTIONS.merge \
      :backend => "FCG",
      :namespace => 'fcg:session',
      :server => 'localhost:11211',
      #:secret => "S9vtS#wPFP'xX=AcLi-B,I#JEjh5h(~RgmZ<XXsi'Ufac<$x8q%._owOtJ>A7'D",
      # We want to extract session id from request parameters.
      :cookie_only => false,
      # But only in few trusted URLs.
      :params_sid_paths => ["/cookies/set","/cookies/get"],
      # Set to true to ignore session tokens sent not via HTTPS.
      # Cookies still can be sent unencrypted, and thus usual man-in-the-middle session hijacking is possible.
      :ssl => false

      def initialize(app, options = {})
        @app = app
        @mutex = Mutex.new

        @options = self.class::DEFAULT_OPTIONS.merge(options)
        @key = @options[:key] || "rack.session"
        @cookie_only = @options.delete(:cookie_only)
        @params_sid_paths = @options.delete(:params_sid_paths)
        @ssl = @options.delete(:ssl)
        @secret = options.delete(:secret)

        # Backend - FCG service store or Memcache ( for testing and backup )
        @pool = Backends::const_get(@options[:backend]).connect(@options[:server])
      end

      def call(env, app=@app)
        load_session(env)
        status, headers, body = app.call(env)
        commit_session(env, status, headers, body)
      end

      private

      def generate_sid
        sidbits = 128
        @sid_template = "%0#{sidbits / 4}x"
        @sid_rand_width = (2**sidbits - 1)

        # Ensure there is no collisions.
        loop do
          sid = @sid_template % SecureRandom.random_number(@sid_rand_width)
          break sid unless @pool.get(sid)
        end
      end

      def load_session(env)
        session_id = extract_session_id(env)

        begin
          session_id, session = get_session(env, session_id)
          env['rack.session'] = session
        rescue
          env['rack.session'] = Hash.new
        end

        env['rack.session.options'] = @options.merge(:id => session_id)
      end


      def extract_session_id(env)
        request = Rack::Request.new(env)

        # Default is to load session from cookies.
        sid = request.cookies[@key]

        # security settings
        predicate = !@cookie_only && (request.ssl? || !@ssl)

        # Load session from @key GET/POST parameter. Used to store cookies via 1x1 img tags.
        # Only @params_sid_paths via HTTPS are allowed, to prevent some session fixation attacks.
        sid ||= request.params[@key] if predicate && @params_sid_paths.include?(request.path_info)

        # Load session from custom HTTP header X-FCG-Session. Could be helpful in APIs etc.
        sid ||= request.env["HTTP_X_FCG_SESSION"] if predicate

        # Session can be signed
        if @secret && sid
          sid, digest = sid.split("--")
          sid = nil  unless digest == generate_hmac(sid)
        end

        sid || generate_sid
      end

      # Base64 encoder && decoder

      def encode(str)
        [str].pack('m') rescue nil
      end

      def decode(str)
        str.unpack('m').first rescue nil
      end

      # Acquires the session from the environment and the session id from
      # the session options and passes them to #set_session. If successful
      # and the :defer option is not true, a cookie will be added to the
      # response with the session's id.
      def commit_session(env, status, headers, body)
        session = env['rack.session']
        options = env['rack.session.options']
        session_id = options[:id]

        if options[:drop] || options[:renew]
          session_id = destroy_session(env, session_id, options)
          return [status, headers, body] unless session_id
        end

        if not data = set_session(env, session_id, session, options)
          env["rack.errors"].puts("Warning! #{self.class.name} failed to save session. Content dropped.")
        elsif options[:defer] and not options[:renew]
          env["rack.errors"].puts("Defering cookie for #{session_id}") if $VERBOSE
        else
          cookie = Hash.new
          cookie[:value] = data
          cookie[:expires] = Time.now + options[:expire_after] if options[:expire_after]
          set_cookie(env, headers, cookie.merge!(options))
        end

        [status, headers, body]
      end

      # Sets the cookie back to the client with session id. We skip the cookie
      # setting if the value didn't change (sid is the same) or expires was given.
      def set_cookie(env, headers, cookie)
        request = Rack::Request.new(env)
        if request.cookies[@key] != cookie[:value] || cookie[:expires]
          Utils.set_cookie_header!(headers, @key, cookie)
        end
      end

      def get_session(env, sid)
        with_lock(env, [nil, {}]) do
          unless sid and session = @pool.get(sid)
            sid, session = generate_sid, {}
            if collision = @pool.get(sid) and collision.is_a? Hash
              raise "Session collision on '#{sid.inspect}'"
            else
              @pool.add(sid,session)
            end
          end
          [sid, session]
        end
      end

      def set_session(env, session_id, new_session, options)
        expiry = options[:expire_after]
        expiry = expiry.nil? ? 0 : expiry + 1

        with_lock(env, false) do
          @pool.set session_id, new_session, expiry
          session_id
        end
      end

      def destroy_session(env, session_id, options)
        with_lock(env) do
          @pool.delete(session_id)
          generate_sid unless options[:drop]
        end
      end

      def with_lock(env, default=nil)
        @mutex.lock if env['rack.multithread']
        yield
      ensure
        @mutex.unlock if @mutex.locked?
      end

      def generate_hmac(data)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, @secret, data)
      end

    end

    module Backends
      module Memcache
        def self.connect(server)
          MemCache.new(server)
        end
      end
      module FCG
        def self.connect(server)
          require 'fcg-service-ext/models/session'
          FCG::Models::Session
        end
      end
    end
  end
end
