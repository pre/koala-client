KoalaClient.configure do |config|
 config.session_expires_after = 15 #minutes from now
 config.public_key_file = File.join("#{RAILS_ROOT}", "/config", 'lintuvaara_public_key.pem')
end