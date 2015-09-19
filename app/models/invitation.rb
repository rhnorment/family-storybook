# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  recipient_email :string           not null
#  token           :string
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Invitation < ActiveRecord::Base

  include         TokenGenerator

  belongs_to      :user
  has_one         :recipient, class_name: 'User'

  validates       :recipient_email, format: { with: /\A\S+@\S+\z/ }
  validates       :recipient_email, presence: true
  validates       :user_id,         presence: true

  after_create    :send_invitation_email
  before_create   :create_invitation_digest

  # check to see if an invitation has already been sent to the recipient email address by the user:
  def self.invitation_exists?(user, recipient_email)
    find_by_user_id_and_recipient_email(user, recipient_email).present?
  end

  # check to see if the user is already relatives with the invitee:
  def already_relatives_with?
    user.relatives.include?(find_by_recipient_email)
  end

  # check to see if the recipient is already a member:
  def find_by_recipient_email
    User.find_by_email(recipient_email)
  end

  # check to see if the user invited himself:
  def invited_self?
    recipient_email == user.email
  end

  # check to see if the user is already a member:
  def recipient_is_member?
    find_by_recipient_email != nil
  end

  protected

    # creates a unique invitation token:
    def create_invitation_digest
      self.token = TokenGenerator.new_token
    end

    # send the invitation email:
    def send_invitation_email
      UserMailer.invitation(self).deliver_now
      update_attribute(:sent_at, Time.zone.now)
    end

end
