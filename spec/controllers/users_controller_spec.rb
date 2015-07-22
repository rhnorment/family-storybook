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

    it 'cannot access show' do
      expect(get :show, id: @user.id).to redirect_to(new_session_url)
    end

    it 'can access new' do
      expect(get :new).to render_template(:new)
    end

    it 'can access create and creates a new user' do
      expect { post :create, user: @new_user }.to change(User, :count).by(+1)
      expect(response).to redirect_to user_url(User.last)
    end

    it 'cannot access edit' do
      expect(get :show, id: @user.id).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      expect(patch :update, id: @user.id).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      expect(delete :destroy, id: @user.id).to redirect_to(new_session_url)
    end
  end

  context 'when signed in as the wrong user' do
    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user.id
    end

    it 'cannot view another user' do
      expect(get :show, id: @user.id).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot edit another user' do
      expect(get :edit, id: @user.id).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot update another user' do
      expect(patch :update, id: @user.id).to redirect_to(user_url(@wrong_user))
    end

    it 'cannot destroy another user' do
      expect(delete :destroy, id: @user).to redirect_to(user_url(@wrong_user))
    end
  end

  context 'when signed in as the current user' do
    before do
      session[:user_id] = @user.id
    end

    it 'can access its dashboard' do
      expect(get :show, id: @user.id).to render_template :show
    end

    it 'can can access its edit page' do
      expect(get :edit, id: @user.id).to render_template :edit
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

  context 'when creating a new user from an invitation token' do

    it 'can access new with an invitation token present' do

    end

  end


end