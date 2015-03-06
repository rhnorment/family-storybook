require 'spec_helper'

describe StorybooksController do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
    @storybook = @user.storybooks.create!(storybook_attributes)
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
      get :show, id: @storybook

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      get :edit, id: @storybook

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      patch :update, id: @storybook

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      delete :destroy, id: @storybook

      expect(response).to redirect_to(new_session_url)
    end

  end

  context 'when signed is as a different user' do

    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user
    end

    it 'cannot view another user storybook' do
      get :show, id: @storybook

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot edit another user storybook' do
      get :edit, id: @storybook

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot update another user storybook' do
      patch :update, id: @storybook

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot destroy another user storybook' do
      delete :destroy, id: @storybook

      expect(response).to redirect_to(user_url(@wrong_user))
    end

  end

end