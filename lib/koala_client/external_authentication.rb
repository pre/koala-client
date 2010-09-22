require 'hpricot'

class KoalaClient::ExternalAuthentication 
  
  attr_accessor :login_type, :login_id, :name, :email, :expires_at, :auth_for
  attr_accessor :login_token
  
  def initialize(login_token)
    self.login_token = login_token
    authorize!
  end

  #########################################################################
  private

  def authorize!
    parse_user!
    if not auth_timestamp_valid? or not auth_for_me?
      raise RuntimeError.new("Invalid login credentials.")
    end
    
    return true
  end

  def auth_for_me?
    Rails.logger.debug("My API account: #{KoalaClient.configuration.api_account}, XML auth_for: #{self.auth_for}")
    KoalaClient.configuration.api_account == self.auth_for
  end
  
  def auth_timestamp_valid?
    # correct: "expires at 3" > "time is now 2"
    # expired: "expires at 3" > "time is now 4"
    Time.at(self.expires_at.to_i).getutc > Time.now.getutc
  end
  
  # Parse user from XML
  #
  # LoginXML example (look for documentation in LoginPrototyyppi):
  #
  # <?xml version="1.0" encoding="UTF-8"?>
  # <login type="rengastaja">
  #   <login_id>1</login_id>
  #   <name>Johannes Korpi</name>
  #   <email>petrus.repo@iki.fi</email>
  #   <expires_at>1242904036</expires_at>
  #   <auth_for>kihla</auth_for>
  # </login>
  def parse_user!
    login_xml = Hpricot.XML(self.login_token) 
    item = (login_xml/:login).first
    self.login_type = item["type"]
    self.login_id = (item/:login_id).inner_html
    self.name = (item/:name).inner_html
    self.email = (item/:email).inner_html
    self.expires_at = (item/:expires_at).inner_html
    self.auth_for = (item/:auth_for).inner_html
    return true 
  end
  
end
