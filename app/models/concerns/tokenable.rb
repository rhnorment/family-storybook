module Tokenable

  def self.new_token
    SecureRandom.urlsafe_base64
  end

end