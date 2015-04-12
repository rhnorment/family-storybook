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
      get :new

      expect(response).to redirect_to(new_session_url)
    end
  end

end
