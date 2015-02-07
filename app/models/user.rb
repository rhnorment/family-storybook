class User < ActiveRecord::Base

  has_secure_password

  validates         :name,  :email, presence: true
  validates         :email, format: { with: /\A\S+@\S+\z/ }
  validates         :email, uniqueness: { case_sensitive: false }

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

end
