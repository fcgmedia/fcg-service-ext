module FCG
  module Authentication
    def self.included(controller)
      controller.send :helper_method, :current_user, :redirect_back_or_default, :require_user, :require_no_user, :sessions_as_json, :logged_in?
    end
  
    protected
      def current_user
        @current_user ||= (session[:user] && User.find(session[:user])) || :false
      end
    
      # Store the given user in the session.
      def current_user=(new_user)
        if new_user.nil? or new_user.is_a?(Symbol)
          session[:user] = nil
        else
          session[:user] = new_user.id.to_s
        end
        @current_user = new_user
      end
    
      def reset_session
        session[:user] = nil
      end
    
      def require_user
        unless logged_in?
          respond_to do |format|
            format.html do
              flash[:error] = "You must first login or sign up before accessing this page."
              store_location
              redirect_to login_url
            end
            format.js{ render :js => sessions_as_json }
          end
        end
      end

      def require_no_user
        if logged_in?
          store_location
          flash[:notice] = "You must be logged out to access this page"
          redirect_to root_url
          return false
        end
      end
    
      def sign_in(user)
        current_user = user
      end

      def store_location
        session[:return_to] = request.request_uri
      end

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end

      def logged_in?
        current_user != :false
      end
    
      def sessions_as_json
        state = if logged_in?
          {
            :session => {
              :username => current_user.username,
              :token => current_user.remember_token
            },
            :timestamp => Time.now.utc.to_s(:rfc822)
          }
        else
          { :session => nil, :timestamp => Time.now.utc.to_s(:rfc822) }
        end
        state.to_json
      end
  end
end