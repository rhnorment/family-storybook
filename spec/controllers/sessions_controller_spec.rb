require 'rails_helper'

describe SessionsController, type: :controller do

  before do
    @user = User.create!(user_attributes)
  end

  context 'when not signed in' do
    it 'presents a new session view' do
      get :new

      expect(response).to render_template('layouts/session')
      expect(response).to render_template :new
    end
  end

  context 'when signed in' do
    before do
      session[:user_id] = @user.id
    end

    it 'prevents a new session view' do
      get :new

      expect(response).to redirect_to(@user)
    end

    it 'deletes the session and redirects to the new session view' do
      delete :destroy

      expect(session[:user_id]).to eql(nil)
      expect(response).to redirect_to signin_url
    end
  end

  context 'when not signed in and using valid credentials' do
    it 'authenticates the user and creates a new session' do
      post :create, user: { email: @user.email, password: 'secret' }

      expect(User.authenticate(@user.email, 'secret')).to eql(@user)
      # expect(session[:user_id]).to eql(@user.id)
    end
  end

  context 'when not signed in and using invalid credentials' do
    it 'does not authenticate the user' do
      post :create, user: { email: 'baduser@example.com', password: 'secret' }

      expect(User.authenticate('bad-user@example.com', 'password')).to eq(nil)
     end
  end

end