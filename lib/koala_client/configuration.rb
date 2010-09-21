# Structure copied from Clearance
module KoalaClient
  class Configuration
    attr_accessor :session_expires_after,
                  :server_host, :server_protocol, :server_url,
                  :server_logout_url, :client_name, :api_account,
                  :client_setup, :private_key_file, :public_key_file,
                  :auth_success_url

    def initialize
      @client_setup          = true # TODO: server setup
      @private_key_file      = ""   # TODO
      @public_key_file       = "unconfigured_public_key_file.pem"
      @auth_success_url      = :root  # ":root" is translated to "root_url"
      
      @session_expires_after = 15 # minutes

      @api_account       = Lintuvaara::ApiConfig::SERVER_ACCOUNT
      @server_host       = Lintuvaara::ApiConfig::SERVER_HOST
      @server_protocol   = Lintuvaara::ApiConfig::SERVER_PROTOCOL
      @server_url        = "#{@server_protocol}#{@server_host}"
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Configure KoalaClient at config/initializers/koala_client.rb
  #
  # @example
  #    KoalaClient.configure do |config|
  #     config.session_expires_after = 15 #minutes from now
  #     config.public_key_file = File.join("#{RAILS_ROOT}", "/config", 'lintuvaara_public_key.pem')
  #    end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
