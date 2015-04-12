# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  recipient_email :string(255)
#  token           :string(255)
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Invitation < ActiveRecord::Base

  # model validations:
  validates       :recipient_email, :user_id, presence: true
  validates       :recipient_email, format: { with: /\A\S+@\S+\z/ }

  # data associations:
  belongs_to      :user
  has_one         :recipient, class_name: 'User'

  # callbacks
  before_create   :create_invitation_digest
  after_create    :send_invitation_email

  # creates a unique invitation token:
  def create_invitation_digest
    self.token = User.new_token
  end

  # check to see if the recipient is the sender:
  def recipient_not_self?
    self.recipient_email != self.user.email
  end

  # check to see if the recipient is already a member:
  def recipient_not_member?
    User.find_by_email(recipient_email).nil?
  end

  # send the invitation email:
  def send_invitation_email
    UserMailer.invitation(self).deliver
    update_attribute(:sent_at, Time.zone.now)
  end

end
