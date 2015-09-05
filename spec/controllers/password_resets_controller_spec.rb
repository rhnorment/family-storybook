require 'rails_helper'

describe PasswordResetsController, type: :controller do

  before { create_user }

  describe 'GET :new' do
    context 'when not signed in'

    context 'when signed in as the current user' do
      before do
        sign_in_current_user
        get :new
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'POST :create' do

    context 'when not signed in' do
      context 'if the user is found' do
        before { post(:create, password_reset: { email: 'user@example.com' }) }

        it { should route(:post, '/password_resets').to(action: :create) }
        it { should respond_with(:ok) }
        it { should render_with_layout(:session) }
        it { should render_template(:new) }
        it { should set_flash.now[:info] }

        it 'user object should receive #create_reset_digest'

        it 'user object should receive #send_password_reset_email'
      end

      context 'if the user is not found' do
        before { post(:create, password_reset: { email: 'wrong_user@example.com' }) }

        it { should respond_with(:ok) }
        it { should render_with_layout(:session) }
        it { should render_template(:new) }
        it { should set_flash.now[:danger] }
      end
    end
  end

  describe 'GET :edit' do
    context 'when not signed in' do
      before do
        @user.create_reset_digest
        get(:edit, id: @user.reset_token, email: 'user@example.com' )
      end

      it { should route(:get, "/password_resets/#{@user.reset_token}/edit").to(action: :edit, id: @user.reset_token) }
      it { should respond_with(:ok) }
      it { should render_with_layout(:session) }
      it { should render_template(:edit) }
      it { should_not set_flash }

      it 'should assign the correct user' do
        expect(assigns(:user)).to eql(@user)
      end
    end
  end

  describe 'PATCH :update' do
    context 'when not signed in' do
      before { @user.create_reset_digest }

      context 'the password reset is blank' do
        before { patch(:update, id: @user.reset_token, email: 'user@example.com', user: { password: '', password_confirmation: '' }) }

        it { should route(:patch, "/password_resets/#{@user.reset_token}").to(action: :update, id: @user.reset_token) }
        it { should respond_with(:ok) }
        it { should render_with_layout(:session) }
        it { should render_template(:edit) }
        it { should set_flash.now[:danger] }
      end

      context 'the password reset is successful' do
        before { patch(:update, id: @user.reset_token, email: 'user@example.com', user: { password: 'secret', password_confirmation: 'secret' }) }

        it { should route(:patch, "/password_resets/#{@user.reset_token}").to(action: :update, id: @user.reset_token) }
        it { should respond_with(:redirect) }
        it { should set_session[:user_id] }
        it { should redirect_to(@user) }
        it { should set_flash[:success] }
      end

      context 'the password reset is unsuccessful' do
        before { patch(:update, id: @user.reset_token, email: 'user@example.com', user: { password: 'secret', password_confirmation: 'wrong' }) }

        it { should route(:patch, "/password_resets/#{@user.reset_token}").to(action: :update, id: @user.reset_token) }
        it { should respond_with(:ok) }
        it { should render_with_layout(:session) }
        it { should render_template(:edit) }
        it { should set_flash.now[:warning] }
      end
    end
  end

end

