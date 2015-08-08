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

  # inclusions:
  to_param            :name
  include             Authentication
  include             PublicActivity::Common
  include             Relatable
  include             Invitable

  # validations:
  validates           :name,  :email, presence: true
  validates           :email, format: { with: /\A\S+@\S+\z/ }
  validates           :email, uniqueness: { case_sensitive: false }

  # data relationships
  has_many            :storybooks,    dependent:  :destroy
  has_many            :stories,       dependent:  :destroy
  has_many            :activities,    as: :trackable, class_name: 'PublicActivity::Activity',   dependent: :destroy

  # callbacks:
  after_create        :create_activity
  before_destroy      :remove_activities

  #  sets user avatar using the gravitar web service:
  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  # generates a new URL token for a variety of functions:
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def create_activity
    PublicActivity::Activity.create   key: 'user.create', trackable_id: self.id, trackable_type: 'User',
                                      recipient_id: self.id, recipient_type: 'User', owner_id: self.id, owner_type: 'User',
                                      created_at: self.created_at, parameters: {}
  end

  def remove_activities
    PublicActivity::Activity.where(owner_id: self.id).delete_all
  end

end

# TODO:  refactor email confirmation and invitation registrations into callbacks

