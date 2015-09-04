require 'rails_helper'

describe SessionsController, type: :controller do
  before { create_user }

  describe 'GET :new' do
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
    before do
      @good_session = { email: 'user@example.com', password: 'secret' }
      @bad_session = { email: 'bad_user@example.com', password: 'secret' }
    end

    context 'when not signed in' do
      before { post(:create, @good_session) }

      it { should route(:post, '/session').to(action: :create) }
      it { should respond_with(:found) }
      it { should redirect_to(storybooks_url) }
      it { should set_flash[:success] }

      it 'should set the session[:user_id] key to the user id' do
        expect(session[:user_id]).to eql(@user.id)
      end
    end

    context 'when signed in as the current user' do
      before do
        sign_in_current_user
        post(:create, @good_session)
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'DELETE :destroy' do
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