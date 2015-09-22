require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET => :show' do
    let(:user)        { create(:user) }
    let(:wrong_user)  { create(:user, :wrong_user) }

    context 'when not signed in' do
      before { get(:show, id: '1') }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        session_for_user
        get(:show, id: user.id )
      end

      it { is_expected.to route(:get, '/users/1-Example-User').to(action: :show, id: '1-Example-User') }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:application) }
      it { is_expected.to render_template(:show) }
      it { is_expected.to_not set_flash }

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eql(user)
      end

      it 'assigns the user name to @page_title' do
        expect(assigns(:page_title)).to eql(user.name)
      end
    end

    context 'when signed in as a different user' do
      before do
        session_for_wrong_user
        get(:show, id: user.id)
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'GET => :new' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :new }

      it { is_expected.to route(:get, '/signup').to(action: :new) }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:session) }
      it { is_expected.to render_template(:new) }
      it { is_expected.to_not set_flash }

      it 'should set @user to be a new object' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context 'when signed in' do
      before do
        session_for_user
        get :new
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'POST => :create' do
    before do
      @new_user = { name: 'New User', email: 'newuser@exaxmple.com', password: 'secret', password_confirmation: 'secret' }
      @bad_user = { name: 'Bad User', email: 'baduser@exaxmple.com', password: nil, password_confirmation: nil }
    end

    context 'when not signed in' do
      describe 'successfully creating a new user' do
        before { post(:create, user: @new_user) }

        it { is_expected.to route(:post, '/users').to(action: :create) }
        it { is_expected.to respond_with(:found) }
        it { is_expected.to redirect_to(user_url(User.last)) }
        it { is_expected.to set_flash[:success] }

        it 'should change the User count' do
          expect(User.count).to eql(1)
        end
      end

      describe 'unsuccessfully creating a new user' do
        before { post(:create, user: @bad_user) }

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
        it { is_expected.to set_flash.now[:danger] }
      end
    end

    context 'when signed in' do
      let(:user) { create(:user) }

      before do
        session_for_user
        post(:create, user: @new_user)
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'GET => :edit' do
    let(:user)        { create(:user) }
    let(:wrong_user)  { create(:user, :wrong_user) }

    context 'when not signed in' do
      before { get :edit, id: user.id }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before do
        session_for_user
        get :edit, id: user.id
      end

      it { is_expected.to route(:get, '/users/1-Example-User/edit').to(action: :edit, id: '1-Example-User') }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:application) }
      it { is_expected.to render_template(:edit) }
      it { is_expected.to_not set_flash }
    end

    context 'when signed is as a different user' do
      before do
        session_for_wrong_user
        get :edit, id: user.id
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'PATCH => :update' do
    let(:user)        { create(:user) }
    let(:wrong_user)  { create(:user, :wrong_user) }

    context 'when not signed in' do
      before { patch(:update, id: user.id, user: { name: 'Example Two User' }) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before { session_for_user }

      context 'when successfully updating a user' do
        before { patch(:update, id: user.id, user: { email: 'change@example.com' }) }

        it { is_expected.to route(:patch, '/users/1-Example-User').to(action: :update, id: '1-Example-User') }
        it { is_expected.to respond_with(:found) }
        it { is_expected.to redirect_to(user) }
        it { is_expected.to set_flash[:success] }

        it 'should have the new email address in the database' do
          expect(user.reload.email).to eql('change@example.com')
        end
      end

      context 'when unsuccessfully updating a user ' do
        before { patch(:update, id: user.id, user: { email: '@example.com' }) }

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
        it { is_expected.to set_flash.now[:warning] }
      end
    end

    context 'when signed in as a different user' do
      before do
        session_for_wrong_user
        patch(:update, id: user.id, user: { name: 'Example Two User' })
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'DELETE => :destroy' do
    let(:user)        { create(:user) }
    let(:wrong_user)  { create(:user, :wrong_user) }

    context 'when not signed in' do
      before { delete(:destroy, id: user.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        session_for_user
        delete(:destroy, id: user.id)
      end

      context 'when successfully deleting a user' do
        it { is_expected.to route(:delete, '/users/1-Example-User').to(action: :destroy, id: '1-Example-User') }
        it { is_expected.to respond_with(:found) }
        it { is_expected.to redirect_to(root_url) }
        it { is_expected.to_not set_flash }
      end
    end
  end

end
