# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  reset_token     :string(255)
#  reset_sent_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base

  # activations:
  has_secure_password
  to_param            :name
  include             PublicActivity::Common

  # data attributes:
  attr_accessor       :reset_token

  # validations:
  validates           :name,  :email, presence: true
  validates           :email, format: { with: /\A\S+@\S+\z/ }
  validates           :email, uniqueness: { case_sensitive: false }

  # data relationships:
  has_many            :storybooks,  dependent: :destroy
  has_many            :stories,     dependent: :destroy
  has_many            :activities,  as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  # scoped queries:


  # callbacks:
  after_create        :create_activity

  # class methods:
  def send_activation_email
    UserMailer.registration_confirmation(self).deliver
  end

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def create_reset_digest
    update_attribute(:reset_token, User.new_token )
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def create_activity
    PublicActivity::Activity.create   key: 'user.create', trackable_id: self.id, trackable_type: 'User',
                                      recipient_id: self.id, recipient_type: 'User', owner_id: self.id,
                                      owner_type: 'User', created_at: self.created_at, parameters: {}
  end

end
