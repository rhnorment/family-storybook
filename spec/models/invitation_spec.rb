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

require 'rails_helper'

describe Invitation, type: :model do

  before do
    @user = User.create!(user_attributes)
  end

  context 'when creating a new invitation' do
    it 'is valid with example attributes' do
      expect(@user.invitations.new(invitation_attributes)).to be_valid
    end

    it 'is invalid with errors without a recipient email' do
      expect(@user.invitations.new(invitation_attributes(recipient_email: nil))).to_not be_valid
    end

    it 'is valid without errors with a proper email address' do
      emails = %w[user@example.com first.last@example.com]

      emails.each do |email|
        expect(@user.invitations.new(invitation_attributes(recipient_email: email))).to be_valid
      end
    end

    it 'it invalid with errors with an improperly formatted email' do
      emails = %w[@ user@ @example.com]

      emails.each do |email|
        expect(@user.invitations.new(invitation_attributes(recipient_email: email))).to_not be_valid
      end
    end
  end

  context 'when associating with a user' do
    it 'belongs to a user' do
      invitation = @user.invitations.new(invitation_attributes)

      expect(invitation.user).to eq(@user)
    end
  end

end