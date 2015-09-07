module PasswordReset

  extend ActiveSupport::Concern

  included do
    attr_accessor       :reset_token
  end

  #  creates a digest for resetting a forgotten password:
  def create_reset_digest
    update_attribute(:reset_token, Tokenable.new_token)
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #  sends an email with password reset instructions:
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #  returns true if the password reset request was sent more than 2 hours ago, else false:
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

end