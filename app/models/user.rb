# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  reset_token     :string
#  reset_sent_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  active          :boolean          default(FALSE)
#

class User < ActiveRecord::Base

  include             Account
  include             Authentication
  include             Family
  include             PasswordReset
  include             TokenGenerator
  include             Trackable

  to_param            :name

  has_many            :activities,    as: :owner
  has_many            :activities,    as: :recipient
  has_many            :stories,       dependent:      :destroy
  has_many            :storybooks,    dependent:      :destroy

  validates           :name,  :email, presence: true
  validates           :email, format: { with: /\A\S+@\S+\z/ }
  validates           :email, uniqueness: { case_sensitive: false }

  before_destroy      :remove_user_activity

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  protected

    def remove_user_activity
      Activity.where(owner: self).delete_all
    end

end

# TODO:  refactor user regisration process.


