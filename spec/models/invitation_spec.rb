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

require 'spec_helper'

describe 'the invitation model' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
  end

  it 'should validate the presence of the user and relative ids' do
    invitation = Invitation.new

    expect(invitation.valid?).to be_false
    expect(invitation.errors).to include(:email)
    expect(invitation.errors).to include(:user_id)
    expect(invitation.errors).to include(:recipient_id)
    expect(invitation.errors.size).to eq(4)
  end

  context 'when sending an invitation' do

    it 'should be pending'

    it 'should not be approved'

  end

  context 'when accepting an invitation' do

    it 'should not be pending'

    it 'should be approved'

  end

  context 'when removing an invitation' do

    it 'the invitation record should not exist'

  end

end
