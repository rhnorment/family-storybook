require 'rails_helper'

describe SessionsController, type: :controller do

  describe 'GET => :new' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :new }

      it { should route(:get, '/signin').to(action: :new) }
      it { should respond_with(:success) }
      it { should render_with_layout(:session) }
      it { should render_template(:new) }
      it { should_not set_flash }
    end

    context 'when signed in as the current user' do
      before do
        session_for_user
        get(:new)
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'POST => :create' do
    let(:user)          { create(:user) }
    let(:inactive_user) { create(:user, :inactive_user) }

    context 'valid and active user' do
      before { post(:create, email: user.email, password: user.password) }

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:redirect) }
      it { should set_session[:user_id].to[user.id] }
      it { should set_flash[:success] }
      it { should redirect_to(storybooks_url) }
    end

    context 'valid and inactive user' do
      before { post(:create, email: inactive_user.email, password: inactive_user.password) }

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:success) }
      it { should_not set_session[:user_id] }
      it { should render_template(:new) }
      it { should set_flash.now[:danger] }
    end

    context 'invalid user' do
      before { post(:create, email:'invalid_user@example.com', password: 'secret') }

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:ok) }
      it { should_not set_session[:user_id] }
      it { should render_template(:new) }
      it { should set_flash.now[:danger] }
    end
  end

  describe 'DELETE :destroy' do
    let(:user) { create(:user) }

    context 'when signed in as the current user' do
      before do
        session_for_user
        delete(:destroy)
      end

      it { should respond_with(:redirect) }
      it { should set_session[:user_id].to(nil) }
      it { should redirect_to(signin_url) }
      it { should set_flash[:info] }
    end
  end

end