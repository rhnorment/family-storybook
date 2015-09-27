require 'rails_helper'

describe Family, type: :concern do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, email: 'user_2@example.com') }
  let(:user_3)  { create(:user, email: 'user_3@example.com') }
  let(:user_4)  { create(:user, email: 'user_4@example.com') }
  let(:user_5)  { create(:user, email: 'user_5@example.com') }
  let(:user_6)  { create(:user, email: 'user_6@example.com') }

  describe 'creating a relationship' do
    context 'valid invitation' do
      it 'should invite other users to be relatives' do
        expect(user.invite(user_2)).to be_truthy
        expect(user_3.invite(user)).to be_truthy
      end
    end

    context 'user is already invited' do
      before { user.invite(user_2) }

      it 'should not invite an already invited user' do
        expect(user.invite(user_2)).to be_falsey
        expect(user_2.invite(user)).to be_falsey
      end
    end

    context 'user is already approved' do
      before do
        user.invite(user_2)
        user_2.approve(user)
      end

      it 'should not invite an already approved user' do
        expect(user.invite(user_2)).to be_falsey
        expect(user_2.invite(user)).to be_falsey
      end
    end

    context 'user invites self' do
      it 'should not create a relationship with self' do
        expect(user.invite(user)).to be_falsey
      end
    end
  end

  describe 'when approving relationships' do
    context 'valid approval' do
      before do
        user.invite(user_2)
        user_3.invite(user)
      end

      it 'should approve only relationships requested by other users' do
        expect(user_2.approve(user)).to be_truthy
        expect(user.approve(user_3)).to be_truthy
      end
    end

    context 'invalid approval' do
      it 'should not approve a non-existing relationship' do
        expect(user_2.approve(user)).to be_falsey
        expect(user.approve(user_3)).to be_falsey
      end
    end

    context 'trying approve an sent invitation' do
      before { user.invite(user_2) }

      it 'should not approve a self-requested relationship' do
        expect(user.approve(user_2)).to be_falsey
      end
    end
  end

  describe 'listing relationships' do
    before do
      user.invite(user_2)
      user.invite(user_4)
      user_4.approve(user)    # relationship
      user_5.invite(user)
      user.approve(user_5)    # relationship
      user_6.invite(user)
      user_4.invite(user_5)
      user_5.approve(user_4)  # other relationship
    end

    it 'should list all relatives' do
      expect(user.relatives).to match_array([user_4, user_5])
    end

    it 'should not list non-relatives' do
      expect(user_2.relatives).to be_empty
      expect(user.relatives).to_not include(user_2, user_3)
    end

    it 'should list all prospective relatives' do
      expect(user.prospective_relatives).to include(user_3)
    end

    it 'should not list all non-prospective relatives' do
      expect(user.prospective_relatives).to_not include(user_2, user_4, user_5)
    end

    it 'should list all the relatives that invited him' do
      expect(user.invited_by).to include(user_5)
      expect(user.invited_by).to_not include(user_2)
    end

    it 'should list all the relatives invited by him' do
      expect(user.invited).to include(user_4)
      expect(user.invited).to_not include(user_2)
    end

    it 'should list the pending relatives who invited him' do
      expect(user.pending_invited_by).to include(user_6)
      expect(user.pending_invited_by).to_not include(user_5)
    end

    it 'should list the pending relatives who were invited by him' do
      expect(user.pending_invited).to include(user_2)
      expect(user.pending_invited).to_not include(user_6)
    end

    it 'should list relatives he has in common with another user' do
      expect(user.common_relatives_with(user_4)).to match_array([user_5])
    end

    it 'should not list relatives he does not have in common with another user' do
      expect(user.common_relatives_with(user_3).count).to eql(0)
      expect(user.common_relatives_with(user_4)).to_not include(user_2, user_3, user_6)
    end

    it 'should check if a user is a relative' do
      expect(user.related_to?(user_4)).to be_truthy
      expect(user_5.related_to?(user)).to be_truthy
    end

    it 'should check it a user is not a relative' do
      expect(user.related_to?(user_2)).to be_falsey
      expect(user_3.related_to?(user)).to be_falsey
    end

    it 'should check if a user has relatives with another user' do
      expect(user_4.connected_with?(user_5)).to be_truthy
      expect(user_5.connected_with?(user_4)).to be_truthy
    end

    it 'should check if a user does not have connections with another user' do
      expect(user_4.connected_with?(user_3)).to be_falsey
      expect(user_3.connected_with?(user_2)).to be_falsey
    end

    it 'should check if a user was invited by another user' do
      expect(user_4.invited?(user_5)).to be_truthy
      expect(user.invited?(user_2)).to be_truthy
    end

    it 'should check if a user was not invited by another user' do
      expect(user.invited?(user_6)).to be_falsey
    end
  end

  describe 'removing relationships' do
    before do
      user.invite(user_2)
      user.invite(user_4)
      user_4.approve(user)    # relationship
      user_5.invite(user)
      user.approve(user_5)    # relationship
      user_6.invite(user)
      user_4.invite(user_5)
      user_5.approve(user_4)  # other relationship
    end

    it 'should not remove relationships that do not exist' do
      expect(user.remove_relationship(user_3)).to be_falsey
    end

    it 'should be removable by the user' do
      expect(user.remove_relationship(user_4)).to be_truthy
      expect(user.remove_relationship(user_5)).to be_truthy
    end

    it 'should be removable by the relative' do
      expect(user_4.remove_relationship(user)).to be_truthy
      expect(user_5.remove_relationship(user)).to be_truthy
    end

    it 'should remove the pending relatives by the user' do
      expect(user.remove_relationship(user_2)).to be_truthy
    end

    it 'should remove the pending relatives by the relative' do
      expect(user_6.remove_relationship(user)).to be_truthy
    end
  end

  describe 'counting relationships' do
    before do
      user.invite(user_2)
      user.invite(user_4)
      user_4.approve(user)    # relationship
      user_5.invite(user)
      user.approve(user_5)    # relationship
      user_6.invite(user)
      user_4.invite(user_5)
      user_5.approve(user_4)  # other relationship
    end

    it 'should return the count for total relatives' do
      expect(user.total_relatives).to eql(2)
      expect(user_2.total_relatives).to eql(0)
      expect(user_3.total_relatives).to eql(0)
      expect(user_4.total_relatives).to eql(2)
      expect(user_5.total_relatives).to eql(2)
      expect(user_6.total_relatives).to eql(0)
    end

    it 'should return the count for total pending relatives' do
      expect(user.total_pending_relatives).to eql(2)
      expect(user_2.total_pending_relatives).to eql(1)
      expect(user_3.total_pending_relatives).to eql(0)
      expect(user_4.total_pending_relatives).to eql(0)
      expect(user_5.total_pending_relatives).to eql(0)
      expect(user_6.total_pending_relatives).to eql(1)
    end

    it 'should return the count for total prospective relatives' do
      expect(user.total_prospective_relatives).to eql(1)
    end
  end

end