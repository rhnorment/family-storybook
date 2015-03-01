require 'spec_helper'

describe StoriesController do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
    @story = @user.stories.create!(story_attributes)
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
      get :show, id: @story

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      get :edit, id: @story

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      patch :update, id: @story

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      delete :destroy, id: @story

      expect(response).to redirect_to(new_session_url)
    end

  end

  context 'when signed is as a different user' do

    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user
    end

    it 'can view another user story' do
      get :show, id: @story

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot edit another user story' do
      get :edit, id: @story

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot update another user story' do
      patch :update, id: @story

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot destroy another user story' do
      delete :destroy, id: @story

      expect(response).to redirect_to(user_url(@wrong_user))
    end


  end



end
