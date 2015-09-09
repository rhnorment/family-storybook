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

  # configuration:
  to_param            :name
  include             TokenGenerator
  include             Authentication
  include             PasswordReset
  include             Family
  include             Trackable

  # validations:
  validates           :name,  :email, presence: true
  validates           :email, format: { with: /\A\S+@\S+\z/ }
  validates           :email, uniqueness: { case_sensitive: false }

  # data relationships
  has_many            :storybooks,    dependent:      :destroy
  has_many            :stories,       dependent:      :destroy
  has_many            :activities,    as: :owner
  has_many            :activities,    as: :recipient

  # callbacks:
  after_create        :send_activation_email
  after_create        :track_activity
  before_destroy      :remove_user_activity

  #  sets user avatar using the gravitar web service:
  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  protected

    # sends an email to a newly registered user:
    def send_activation_email
      UserMailer.registration_confirmation(self).deliver_now
    end

    def remove_user_activity
      Activity.where(owner: self).delete_all
    end

end


