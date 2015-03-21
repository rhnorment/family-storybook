require 'spec_helper'

describe InvitationsController do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  context 'when not signed in' do

    before do
      session[:user_id] = nil
    end

    it 'cannot access new' do
      get :new, id: @invitation

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      get :edit, id: @invitation

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      patch :update, id: @invitation

      expect(response).to redirect_to(new_session_url)
    end

  end

end
