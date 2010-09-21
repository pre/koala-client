require 'openssl'  
require 'base64'

class KoalaClient::AuthenticationToken

  attr_accessor :base64_data, :base64_key, :base64_iv, :plain_data

  @@private_key = OpenSSL::PKey::RSA.new(File.read(KoalaClient.configuration.private_key_file)) unless KoalaClient.configuration.client_setup
  @@public_key = OpenSSL::PKey::RSA.new(File.read(KoalaClient.configuration.public_key_file))  
    
  # Parameter data is defined as follows:
  #  when :plain ==> Plain-text Login-XML data
  #  when :encrypted ==> Data is a following hash:
  #      data = { :key => "base64-encoded encrypted AES-key",
  #               :iv  => "base64-encoded encrypted AES initialization vector",
  #               :data => "base64-encoded encrypted login-XML data" }
  def initialize(data, format)
    case format when :plain
      self.plain_data = data
      self.encrypt_sensitive
    when :encrypted
      self.base64_data = data[:data]
      self.base64_key  = data[:key]
      self.base64_iv   = data[:iv]
      self.decrypt_sensitive
    else
      raise ArgumentError.new("Incorrect format parameter '#{format}', only :plain and :encrypted allowed.")
    end
  end
  
  protected
    
  def decrypt_sensitive(data = {})  
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')  
    cipher.decrypt  
    cipher.key = @@public_key.public_decrypt(Base64.decode64(self.base64_key))  
    cipher.iv = @@public_key.public_decrypt(Base64.decode64(self.base64_iv))  

    decrypted_data = cipher.update(Base64.decode64(self.base64_data))
    decrypted_data << cipher.final
    
    self.plain_data = decrypted_data
  end    
  
  def encrypt_sensitive
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')  
    cipher.encrypt  
    cipher.key = random_key = cipher.random_key  
    cipher.iv = random_iv = cipher.random_iv  

    encrypted_data = cipher.update(self.plain_data)  
    encrypted_data << cipher.final 
    self.base64_data = Base64.encode64(encrypted_data) 

    self.base64_key = Base64.encode64(@@private_key.private_encrypt(random_key))
    self.base64_iv = Base64.encode64(@@private_key.private_encrypt(random_iv))
  end
end
