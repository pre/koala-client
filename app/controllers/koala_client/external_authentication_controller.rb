class KoalaClient::ExternalAuthenticationController < ApplicationController
  
  skip_before_filter :authentication_required
  
  def new
    begin
      login_token = KoalaClient::AuthenticationToken.new({:iv => params["iv"],
                                                          :key => params["key"],
                                                          :data => params["data"]}, :encrypted)                                            
      user = KoalaClient::ExternalAuthentication.new(login_token.plain_data)
    rescue 
      flash[:warning] = I18n.t('flash.service_login_failed')
      redirect_to failed_external_authentication_url and return
    end
    
    # Authenticated!
    session[:user] = user.login_id
    session[:user_type] = user.login_type
    
    # Redirect to index or do we have a specific URI from Lintuvaara
    if params[:service_uri].blank?
      #redirect_to (user.login_type == "admin" ? admin_index_url : user_index_url)
      redirect_to KoalaClient.configuration.auth_success_url
    else
      service_uri_with_locale = add_locale_param_to_uri(params[:service_uri], params[:locale])
      redirect_to service_uri_with_locale
    end

  end

  # Failed logins
  def failed
    render(&:html)
  end

  ## TODO: Remove route
  # def index
  #   redirect_to admin_index_url
  # end

  def logout
    reset_session
    lintuvaara_logout_url = add_locale_param_to_uri(KoalaClient.configuration.server_logout_url, I18n.locale)
    redirect_to lintuvaara_logout_url
  end

  protected

  # Adds locale parameter to the service uri unless it already has locale parameter.
  # 1) /kihla/admin/poolfiles/list?type=A
  #    -->  /kihla/admin/poolfiles/list?type=A&locale=LOCALE
  # 2) /kihla/admin/poolfiles
  #    -->  /kihla/admin/poolfiles?locale=LOCALE
  # 3) /kihla/admin/poolfiles?locale=XX
  #    --> /kihla/admin/poolfiles?locale=XX
  def add_locale_param_to_uri(uri, locale)
    if uri.include?("locale=")
      return uri
    end
    
    if uri.include?("?")
      return uri + "&locale=#{locale}"
    else
      return uri + "?locale=#{locale}"
    end
  end

end
