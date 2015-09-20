require 'rails_helper'

describe SessionsController, type: :controller do

  describe 'GET :new' do
    before { create_user }

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
        sign_in_current_user
        get(:new)
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'POST :create' do
    before { create_user }

    context 'valid and active user' do
      before { post(:create, email: 'user@example.com', password: 'secret') }

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:found) }
      it { should set_session[:user_id] }
      it { should redirect_to(storybooks_url) }
      it { should set_flash[:success] }

      it 'should set the session[:user_id] key to the user id' do
        expect(session[:user_id]).to eql(@user.id)
      end
    end

    context 'valid and inactive user' do
      before do
        create_inactive_user
        post(:create, email: 'inactive@example.com', password: 'secret')
      end

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:ok) }
      it { should_not set_session[:user_id] }
      it { should render_template(:new) }
      it { should set_flash.now[:danger] }
    end

    context 'invalid user' do
      before { post(:create, email:'bad_user@example.com', password: 'secret') }

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:ok) }
      it { should_not set_session[:user_id] }
      it { should render_template(:new) }
      it { should set_flash.now[:danger] }
    end
  end

  describe 'DELETE :destroy' do
    before { create_user }

    context 'when signed in as the current user' do
      before do
        sign_in_current_user
        delete(:destroy)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(signin_url) }
      it { should set_flash[:info] }

      it 'should make sure the :user_id key in the session hash is nil' do
        expect(session[:user_id]).to be_nil
      end
    end
  end

end