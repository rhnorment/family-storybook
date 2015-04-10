# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  recipient_email :string(255)
#  token           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Invitation < ActiveRecord::Base

  # model validations:
  validates       :recipient_email, :user_id,  :token, presence: true
  validates       :recipient_email, format: { with: /\A\S+@\S+\z/ }

  # data associations:
  belongs_to      :user
  has_one         :recipient, class_name: 'User'

  # callbacks
  before_create   :create_invitation_token

  # creates a unique invitation token:
  def create_invitation_token
    self.token = User.new_token
  end

end
