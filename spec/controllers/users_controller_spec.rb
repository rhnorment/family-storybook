require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET :show' do
    before { create_user }

    context 'when not signed in' do
      before do
        sign_out_current_user
        get :show, id: @user.id
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before do
        sign_in_current_user
        get :show, id: @user.id
      end

      it { should route(:get, '/users/1-Example-User').to(action: :show, id: '1-Example-User') }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:show) }
      it { should_not set_flash }

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eql(@user)
      end

      it 'assigns the user name to @page_title' do
        expect(assigns(:page_title)).to eql(@user.name)
      end

      it 'assigns the associated collections to @user'
    end

    context 'when signed is as a different user' do
      before do
        create_and_sign_in_wrong_user
        get :show, id: @user.id
      end

      it_behaves_like 'signed in as a different user'
    end

  end

  describe 'GET :new' do
    before { create_user }

    context 'when not signed in' do
      before { get :new }

      it { should route(:get, '/signup').to(action: :new) }
      it { should respond_with(:success) }
      it { should render_with_layout(:session) }
      it { should render_template(:new) }
      it { should_not set_flash }

      it 'should set @user to be a new object' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context 'when signed in' do
      before do
        sign_in_current_user
        get :new
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'POST :create' do
    before do
      create_user
      @new_user = { name: 'New User', email: 'newuser@exaxmple.com', password: 'secret', password_confirmation: 'secret' }
      @bad_user = { name: 'Bad User', email: 'baduser@exaxmple.com', password: nil, password_confirmation: nil }
    end

    context 'when not signed in' do
      context 'upon successfully creating a new user' do
        before do
          sign_out_current_user
          post(:create, user: @new_user)
        end
        it { should route(:post, '/users').to(action: :create) }
        it { should respond_with(:found) }
        it { should redirect_to(user_url(User.last)) }
        it { should set_flash[:success] }

        it 'should change the User count' do
          expect(User.count).to eql(2)  # initial user + newly created user from test action.
        end
      end

      context 'when unsuccessfully creating a new user' do
        before { post(:create, user: @bad_user) }

        it { should respond_with(:success) }
        it { should render_template(:new) }
        it { should_not set_flash }
      end
    end

    context 'when signed in' do
      before do
        sign_in_current_user
        post(:create, user: @new_user)
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'GET :edit' do
    before { create_user }

    context 'when not signed in' do
      before do
        sign_out_current_user
        get :edit, id: @user.id
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before do
        sign_in_current_user
        get :edit, id: @user.id
      end

      it { should route(:get, '/users/1-Example-User/edit').to(action: :edit, id: '1-Example-User') }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:edit) }
      it { should_not set_flash }
    end

    context 'when signed is as a different user' do
      before do
        create_and_sign_in_wrong_user
        get :edit, id: @user.id
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'PATCH :update' do
    before { create_user }

    context 'when not signed in' do
      before do
        sign_out_current_user
        patch(:update, id: @user.id, user: { name: 'Example Two User' })
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before { sign_in_current_user }

      context 'when successfully updating a user' do
        before { patch(:update, id: @user.id, user: { email: 'change@example.com' }) }

        it { should route(:patch, '/users/1-Example-User').to(action: :update, id: '1-Example-User') }
        it { should respond_with(:found) }
        it { should redirect_to(@user) }
        it { should set_flash[:success] }

        it 'should have the new email address in the database' do
          expect(@user.reload.email).to eql('change@example.com')
        end
      end

      context 'when unsuccessfully updating a user ' do
        before { patch(:update, id: @user.id, user: { email: '@example.com' }) }

        it { should respond_with(:success) }
        it { should render_template(:edit) }
        it { should_not set_flash }
      end
    end

    context 'when signed in as a different user' do
      before do
        create_and_sign_in_wrong_user
        patch(:update, id: @user.id, user: { name: 'Example Two User' })
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'DELETE :destroy' do
    before { create_user }

    context 'when not signed in' do
      before do
        sign_out_current_user
        delete(:destroy, id: @user.id)
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        sign_in_current_user
        delete(:destroy, id: @user.id)
      end

      context 'when successfully deleting a user' do
        it { should route(:delete, '/users/1-Example-User').to(action: :destroy, id: '1-Example-User') }
        it { should respond_with(:found) }
        it { should redirect_to(root_url) }
        it { should_not set_flash }

        it 'should remove the user from the database' do
          expect(User.count).to eql(0)
        end
      end
    end

    context 'when signed in as a different user' do
      before do
        create_and_sign_in_wrong_user
        delete(:destroy, id: @user.id)
      end

      it_behaves_like 'signed in as a different user'
    end
  end

end

# TODO:  determine how to test collections.

# TODO: add specs for creating a new user from an invitation token