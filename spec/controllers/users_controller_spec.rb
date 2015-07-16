require 'rails_helper'

describe UsersController, type: :controller do

  before do
    @user = User.create!(user_attributes)
  end

  context 'when not signed in' do
    before do
      @new_user = { name: 'New User', email: 'newuser@exaxmple.com', password: 'secret', password_confirmation: 'secret' }
      session[:user_id] = nil
    end

    it 'can be access new' do
      expect(get :new).to render_template(:new)
    end

    it  'creates a new user' do
      expect { post :create, user: @new_user }.to change(User, :count).by(+1)
    end

    it 'cannot access show' do
      get :show, id: @user.id

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      get :edit, id: @user.id

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      patch :update, id: @user.id

      expect(response).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      delete :destroy, id: @user.id

      expect(response).to redirect_to(new_session_url)
    end
  end

  context 'when signed in as the wrong user' do
    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user
    end

    it 'cannot view another user' do
      get :show, id: @user

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot edit another user' do
      get :edit, id: @user

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot update another user' do
      patch :update, id: @user

      expect(response).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot destroy another user' do
      delete :destroy, id: @user

      expect(response).to redirect_to(user_url(@wrong_user))
    end
  end

  context 'when properly signed in' do
    before do
      session[:user_id] = @user
    end

    it 'can access its dashboard' do
      get :show, id: @user.id
      expect(response).to render_template :show
    end

    it 'can can access its edit page' do
      get :edit, id: @user.id
      expect(response).to render_template :edit
    end

    it 'can update its information and redirect to the edit view' do
      expect {
        patch :update, id: @user.id, user: { email: 'exampleuser2@example.com' }
        @user.reload
      }.to change(@user, :email).to('exampleuser2@example.com')
      expect(response).to redirect_to(@user)
    end

    it 'can delete its account' do
      expect { post :destroy, id: @user.id }.to change(User, :count).by(-1)
      expect(response).to redirect_to root_url
    end
  end


end