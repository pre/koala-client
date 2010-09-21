module Lintuvaara
  
  # HTTP API Configuration for Active Resource
  module ApiConfig
  
    # Defaults              
    api_password               = "youwillneverguessthispassword"
    api_account                = "NAME_OF_THIS_CLIENT"
    lintuvaara_api_proto       = "http://"
    lintuvaara_api_host        = "lv.local"
    lintuvaara_api_uri         = "/api"
    lintuvaara_auth_uri        = "/sessions"
    lintuvaara_preferences_uri = "/user_preferences"
    lintuvaara_logout_uri      = "/sessions/logout"
    
    # case Kihla.current_environment
    # when 'live'
    #   # Apply live settings
    # when 'staging'
    #   # Apply staging settings
    # when 'petrus-devel'
    #   # Use defaults
    # else
    #   raise "No environment available for Lintuvaara ApiConfig!"
    # end
    
    
    ### No configuration below this point ###
    #              
    SERVER_HOST       = lintuvaara_api_host
    API_URI           = lintuvaara_api_uri
    AUTH_URI          = lintuvaara_auth_uri
    PREFERENCES_URI   = lintuvaara_preferences_uri
    LOGOUT_URI        = lintuvaara_logout_uri
    SERVER_ACCOUNT    = api_account
    SERVER_PASSWORD   = api_password
    SERVER_PROTOCOL   = lintuvaara_api_proto
    
    SERVER_BASE_URL        = "#{SERVER_PROTOCOL}#{SERVER_HOST}"
    SERVER_API_ADDRESS     = "#{SERVER_BASE_URL}#{API_URI}"
    SERVER_AUTH_ADDRESS    = "#{SERVER_BASE_URL}#{AUTH_URI}"
    SERVER_PUBLIC_ADDRESS  = SERVER_BASE_URL
    SERVER_PREFERENCES_URL = "#{SERVER_BASE_URL}#{PREFERENCES_URI}"
    SERVER_LOGOUT_URL      = "#{SERVER_BASE_URL}#{LOGOUT_URI}"

  end
  
end