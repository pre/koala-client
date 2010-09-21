# Structure copied from Clearance
module KoalaClient
  module Authentication
    def self.included(controller) # :nodoc:
      controller.send(:include, InstanceMethods)
      controller.extend(ClassMethods)
    end

    module ClassMethods
      def self.extended(controller)
        # controller.helper_method :current_user, :signed_in?, :signed_out?
        # controller.hide_action   :current_user, :current_user=,
        #                          :signed_in?,   :signed_out?,
        #                          :sign_in,      :sign_out,
        #                          :authenticate, :deny_access
        controller.hide_action  :authentication_required, :access_granted?, 
                                :correct_user_type?, :set_user_variable,
                                :redirect_to_auth_service, :update_session_expiry
      end
    end

    module InstanceMethods
      # before_filter :authentication_required
      # before_filter :update_session_expiry

      protected

      def authentication_required
        if session[:user] and not correct_user_type?
          redirect_to failed_external_authentication_url and return false
        elsif not access_granted?
          redirect_to_auth_service and return false
        end   
        set_user_variable
      end

      # Controllers which need authentication must implement this feature or inherit it from Admin or User Controller.
      def access_granted?
        raise NotImplementedError.new("Implement #access_granted? which returns true if current user has an authenticated session and is of allowed type (e.g. 'session[:user] and session[:user_type] == \"admin\"').")
      end

      # Controllers which need authentication must implement this feature or inherit it from Admin or User Controller.
      def correct_user_type?
        raise NotImplementedError.new("Implement #correct_user_type? which returns true if current user classification is ok (e.g. return false if a non-admin user is trying to access admin functions, or '[\"rengastaja\", \"maallikko\", \"rengastuskeskus\"].include?(session[:user_type])')")
      end    

      def set_user_variable    
        raise NotImplementedError.new("Implement #set_user_variable which sets @user -- user info is strored in session[:user].")
      end

      # Redirects user to Lintuvaara for authentication. 
      # Delivers the requested URI in order for Lintuvaara to redirect user back.
      def redirect_to_auth_service
        auth_service_url   = Lintuvaara::ApiConfig::SERVER_AUTH_ADDRESS
        my_service_id      = Lintuvaara::ApiConfig::SERVER_ACCOUNT
        request_uri        = CGI.escape(request.request_uri)
        redirect_to "#{auth_service_url}?service=#{my_service_id}&service_uri=#{request_uri}"
      end

      # Session expiry (before_filter)
      def update_session_expiry
        session_expires_at = KoalaClient.configuration.session_expires_after.minutes.from_now

        # first-time?
        session[:expires_at] = session_expires_at unless session[:expires_at]

        # Updates expiry on every request or resets session if it has been idle too long
        if session[:expires_at] > Time.now
          session[:expires_at] = session_expires_at
        else
          reset_session
        end

        return true
      end      

    end
  end
end