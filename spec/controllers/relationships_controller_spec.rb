require 'rails_helper'

describe RelationshipsController, type: :controller do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com'))
    session[:user_id] = @user1.id
    @relationship = @user1.relationships.create!(relative: @user2)
  end

  context 'when not signed in' do
    before do
      session[:user_id] = nil
    end

    it 'cannot access index' do
      expect(get :index).to redirect_to(new_session_url)
    end

    it 'cannot access pending' do
      expect(get :pending).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      expect(patch :update, id: @relationship).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      expect(delete :destroy, id: @relationship).to redirect_to(new_session_url)
    end
  end

  context 'when creating relationships' do
    before do
      Relationship.delete_all
    end

    it 'should invite other users to be family members' do
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user3.invite(@user1)).to eql(true)
    end

    it 'should approve only relationships requested by other users' do
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user2.approve(@user1)).to eql(true)
      expect(@user3.invite(@user1)).to eql(true)
      expect(@user1.approve(@user3)).to eql(true)
    end

    it 'should not invite an already invited user' do
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user1.invite(@user2)).to eql(false)
      expect(@user2.invite(@user1)).to eql(false)
    end

    it 'should not invite an already approved user' do
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user2.approve(@user1)).to eql(true)
      expect(@user2.invite(@user1)).to eql(false)
      expect(@user1.invite(@user2)).to eql(false)
    end

    it 'should not approve a self-requested relationship' do
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user1.approve(@user2)).to eql(false)
      expect(@user3.invite(@user1)).to eql(true)
      expect(@user3.approve(@user1)).to eql(false)
    end

    it 'should not create a relationship with itself' do
      expect(@user1.invite(@user1)).to eql(false)
    end

    it 'should not approve a non-existent relationship' do
      expect(@user4.approve(@user1)).to eql(false)
    end
  end

  context 'when listing relationships' do
    before do
      Relationship.delete_all
      expect(@user1.invite(@user2)).to eql(true)    # john invites jane
      expect(@user3.invite(@user1)).to eql(true)    # peter invites john
      expect(@user1.invite(@user4)).to eql(true)    # john invites james
      expect(@user4.approve(@user1)).to eql(true)   # james approves john
      expect(@user5.invite(@user1)).to eql(true)    # mary invites john
      expect(@user1.approve(@user5)).to eql(true)   # john approves mary
    end

    it 'should list all the relatives' do
      expect(@user1.relatives).to match_array([@user4, @user5])
    end

    it 'should not list non-connection relationships' do
      expect(@user1.relatives).to match_array([@user4, @user5])
      expect(@user2.relatives).to_not include(@user1)
      expect(@user3.relatives).to_not include(@user1)
    end

    it 'should list the relatives who invited the user' do
      expect(@user1.invited_by).to eq([@user5])
    end

    it 'should list the relatives who were invited by the user' do
      expect(@user1.invited).to eq([@user4])
    end

    it 'should list the pending relationships who invited the user' do
      expect(@user1.pending_invited).to eq([@user2])
    end

    it 'should list the pending relationships invited by the user' do
      expect(@user2.pending_invited_by).to eq([@user1])
    end

    it 'should list the relationships in common with a given user' do
      expect(@user4.common_relatives_with(@user5)).to eq([@user1])
    end

    it 'should not list the relationships not in common with a given user' do
      expect(@user1.common_relatives_with(@user5).count).to eq(0)
      expect(@user1.common_relatives_with(@user5)).to_not include(@user4)
      expect(@user1.common_relatives_with(@user3).count).to eq(0)
      expect(@user1.common_relatives_with(@user3)).to_not include(@user2)
    end

    it 'should check if a given user is a relative' do
      expect(@user1.related_to?(@user4)).to eql(true)
      expect(@user4.related_to?(@user1)).to eql(true)
      expect(@user1.related_to?(@user5)).to eql(true)
      expect(@user5.related_to?(@user1)).to eql(true)
    end

    it 'should check is a user is not a relative' do
      expect(@user1.related_to?(@user2)).to eql(false)
      expect(@user2.related_to?(@user1)).to eql(false)
      expect(@user1.related_to?(@user3)).to eql(false)
      expect(@user3.related_to?(@user1)).to eql(false)
    end

    it 'should check if a user has any connections with another user' do
      expect(@user1.connected_with?(@user2)).to eql(true)
      expect(@user2.connected_with?(@user1)).to eql(true)
      expect(@user1.connected_with?(@user3)).to eql(true)
      expect(@user3.connected_with?(@user1)).to eql(true)
    end

    it 'should check if a user does not have any connections with another user' do
      expect(@user2.connected_with?(@user3)).to eql(false)
      expect(@user3.connected_with?(@user2)).to eql(false)
    end

    it 'should check if a user was invited by another' do
      expect(@user2.invited_by?(@user1)).to eql(true)
      expect(@user4.invited_by?(@user1)).to eql(true)
    end

    it 'should check if a user was not invited by another' do
      expect(@user1.invited_by?(@user2)).to eql(false)
      expect(@user3.invited_by?(@user1)).to eql(false)
    end

    it 'should check if a user has invited another user' do
      expect(@user1.invited?(@user2)).to eql(true)
      expect(@user1.invited?(@user4)).to eql(true)
    end

    it 'should check if a user has not invited another user' do
      expect(@user2.invited?(@user1)).to eql(false)
      expect(@user4.invited?(@user1)).to eql(false)
      expect(@user3.invited?(@user4)).to eql(false)
    end
  end

  context 'when removing relationships' do
    before do
      Relationship.delete_all
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user2.approve(@user1)).to eql(true)
      expect(@user2.invite(@user3)).to eql(true)
      expect(@user3.approve(@user2)).to eql(true)
      expect(@user3.invite(@user4)).to eql(true)
      expect(@user4.approve(@user3)).to eql(true)
      expect(@user3.invite(@user5)).to eql(true)
      expect(@user5.approve(@user3)).to eql(true)
      expect(@user4.invite(@user5)).to eql(true)
    end

    it 'should remove the relatives invited by the user' do
      expect(@user3.relatives.size).to eq(3)
      expect(@user3.relatives).to include(@user4)
      expect(@user3.invited).to include(@user4)
      expect(@user4.relatives.size).to eq(1)
      expect(@user4.relatives).to include(@user3)
      expect(@user4.invited_by).to include(@user3)

      expect(@user3.remove_relationship(@user4)).to eql(true)
      expect(@user3.relatives.size).to eq(2)
      expect(@user3.relatives).to_not include(@user4)
      expect(@user3.invited).to_not include(@user4)
      expect(@user4.relatives.size).to eq(0)
      expect(@user4.relatives).to_not include(@user3)
      expect(@user4.invited_by).to_not include(@user3)
    end

    it 'should remove the relatives who invited the user' do
      expect(@user3.relatives.size).to eq(3)
      expect(@user3.relatives).to include(@user2)
      expect(@user3.invited_by).to include(@user2)
      expect(@user2.relatives.size).to eq(2)
      expect(@user2.relatives).to include(@user3)
      expect(@user2.invited).to include(@user3)

      expect(@user3.remove_relationship(@user2)).to eql(true)
      expect(@user3.relatives.size).to eq(2)
      expect(@user3.relatives).to_not include(@user2)
      expect(@user3.invited_by).to_not include(@user2)
      expect(@user2.relatives.size).to eq(1)
      expect(@user2.relatives).to_not include(@user3)
      expect(@user2.invited).to_not include(@user3)
    end

    it 'should remove the pending relationships invited by the user' do
      expect(@user4.pending_invited.size).to eq(1)
      expect(@user4.pending_invited).to include(@user5)
      expect(@user5.pending_invited_by.size).to eq(1)
      expect(@user5.pending_invited_by).to include(@user4)

      expect(@user4.remove_relationship(@user5)).to eql(true)
      expect(@user4.pending_invited.size).to eq(0)
      expect(@user4.pending_invited).to_not include(@user5)
      expect(@user5.pending_invited_by.size).to eq(0)
      expect(@user5.pending_invited_by).to_not include(@user4)
    end

    it 'should remove the pending relationships sent to the user' do
      expect(@user5.pending_invited_by.size).to eq(1)
      expect(@user5.pending_invited_by).to include(@user4)
      expect(@user4.pending_invited.size).to eq(1)
      expect(@user4.pending_invited).to include(@user5)

      expect(@user5.remove_relationship(@user4)).to eql(true)
      expect(@user5.pending_invited_by.size).to eq(0)
      expect(@user5.pending_invited_by).to_not include(@user4)
      expect(@user4.pending_invited.size).to eq(0)
      expect(@user4.pending_invited).to_not include(@user5)
    end
  end

  context 'when counting relationships' do
    before do
      Relationship.delete_all
      expect(@user1.invite(@user2)).to eql(true)
      expect(@user2.approve(@user1)).to eql(true)
      expect(@user1.invite(@user3)).to eql(true)
      expect(@user3.approve(@user1)).to eql(true)
      expect(@user4.invite(@user1)).to eql(true)
      expect(@user1.approve(@user4)).to eql(true)
      expect(@user2.invite(@user5)).to eql(true)
      expect(@user5.approve(@user2)).to eql(true)
      expect(@user5.remove_relationship(@user2)).to eql(true)
      expect(@user5.invite(@user1)).to eql(true)
    end

    it 'should return the correct count for total_friends' do
      expect(@user1.total_relatives).to eq(3)
      expect(@user2.total_relatives).to eq(1)
      expect(@user3.total_relatives).to eq(1)
      expect(@user4.total_relatives).to eq(1)
    end
  end

end