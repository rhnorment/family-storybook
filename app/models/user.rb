# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base

  # inclusions:
  has_secure_password

  # validations:
  validates         :name,  :email, presence: true
  validates         :email, format: { with: /\A\S+@\S+\z/ }
  validates         :email, uniqueness: { case_sensitive: false }

  # data relationships:

  # callbacks:

  # class methods:
  def send_activation_email
    UserMailer.registration_confirmation(self).deliver
  end

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

end
