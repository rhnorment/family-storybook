# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  sender_id       :integer
#  recipient_email :string(255)
#  token           :string(255)
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe 'the invitation model' do

  it 'requires an email address' do
    invitation = Invitation.new(recipient_email: '')
    invitation.valid?
    expect(invitation.errors[:recipient_email].any?).to be_true
  end

  it 'accepts a properly formatted email' do
    emails = %w[user@example.com first.last@example.com]
    emails.each do |email|
      invitation = Invitation.new(recipient_email: email)
      invitation.valid?
      expect(invitation.errors[:recipient_email].any?).to be_false
    end
  end

  it 'rejects an improperly formatted email' do
    emails = %w[@ user@ @example.com]
    emails.each do |email|
      invitation = Invitation.new(recipient_email: email)
      invitation.valid?
      expect(invitation.errors[:recipient_email].any?).to be_true
    end
  end

  it 'is valid with example attributes' do
    invitation = Invitation.new(invitation_attributes)
    expect(invitation.valid?).to be_true
  end

end
