require 'spec_helper'

describe RelationshipsController do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    sign_in(@user1)
    @relationship = @user1.relationships.create!(relative: @user2)
  end

  context 'when not signed in' do
    before do
      session[:user_id] = nil
    end

    it 'cannot access index' do
      get :index

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access show' do
      get :show, id: @relationship

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      get :edit, id: @relationship

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      patch :update, id: @relationship

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      delete :destroy, id: @relationship

      expect(response).to redirect_to(new_session_url)
    end

  end

  context 'when signed is as a different user' do

    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user
    end

    it 'cannot view another user relationship' do
      get :show, id: @relationship

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot edit another user relationship' do
      get :edit, id: @relationship

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot update another user relationship' do
      patch :update, id: @relationship

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot destroy another user relationship' do
      delete :destroy, id: @relationship

      expect(response).to redirect_to(user_url(@wrong_user))
    end

  end

  context 'when creating relationships' do

    before do
      Relationship.delete_all
    end

    it 'should invite other users to be family members' do
      expect(@user1.invite(@user2)).to be_true
      expect(@user3.invite(@user1)).to be_true
    end

    it 'should approve only relationships requested by other users' do
      expect(@user1.invite(@user2)).to be_true
      expect(@user2.approve(@user1)).to be_true
      expect(@user3.invite(@user1)).to be_true
      expect(@user1.approve(@user3)).to be_true
    end

    it 'should not invite an already invited user' do
      expect(@user1.invite(@user2)).to be_true
      expect(@user1.invite(@user2)).to be_false
      expect(@user2.invite(@user1)).to be_false
    end

    it 'should not invite an already approved user' do
      expect(@user1.invite(@user2)).to be_true
      expect(@user2.approve(@user1)).to be_true
      expect(@user2.invite(@user1)).to be_false
      expect(@user1.invite(@user2)).to be_false
    end

    it 'should not approve a self-requested relationship' do
      expect(@user1.invite(@user2)).to be_true
      expect(@user1.approve(@user2)).to be_false
      expect(@user3.invite(@user1)).to be_true
      expect(@user3.approve(@user1)).to be_false
    end

    it 'should not create a relationship with itself' do
      expect(@user1.invite(@user1)).to be_false
    end

    it 'should not approve a non-existent relationship' do
      expect(@user4.approve(@user1)).to be_false
    end

  end

end