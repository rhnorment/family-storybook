require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET :show' do
   before { @user = User.create(user_attributes) }

    context 'when not signed in' do
      before do
        session[:user_id] = nil
        get :show, id: @user.id
      end

      it_behaves_like 'a user not signed in'
    end

    context 'when signed in' do
      before do
        session[:user_id] = @user.id
        get :show, id: @user.id
      end

      describe 'routes and responses' do
        it { should route(:get, '/users/1-Example-User').to(action: :show, id: '1-Example-User') }
        it { should respond_with(:success) }
        it { should render_with_layout(:application) }
        it { should render_template(:show) }
        it { should_not set_flash }
      end

      describe 'variable assignments' do
        it 'assigns the requested user to @user' do
          expect(assigns(:user)).to eql(@user)
        end

        it 'assigns the user name to @page_title' do
          expect(assigns(:page_title)).to eql(@user.name)
        end

        it 'assigns the associated collections to @user'
      end
    end

    context 'when signed is as a different user' do
      before do
        @wrong_user = User.create!(wrong_user_attributes)
        session[:user_id] = @wrong_user.id
        get :show, id: @user.id
      end

      it_behaves_like 'signed in as a different user'
    end

  end

  describe 'GET :new' do
    context 'when not signed in' do
      before { get :new }

      describe 'routes and responses' do
        it { should route(:get, '/signup').to(action: :new) }
        it { should respond_with(:success) }
        it { should render_with_layout(:session) }
        it { should render_template(:new) }
        it { should_not set_flash }
      end

      describe 'variable assignments' do
        it 'should set @user to be a new object' do
          expect(assigns(:user)).to be_a_new(User)
        end
      end
    end

    context 'when signed in' do
      before do
        @user = User.create(user_attributes)
        session[:user_id] = @user.id
        get :new
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'POST :create' do
    before do
      session[:user_id] = nil
      @new_user = { name: 'New User', email: 'newuser@exaxmple.com', password: 'secret', password_confirmation: 'secret' }
      @bad_user = { name: 'Bad User', email: 'baduser@exaxmple.com', password: nil, password_confirmation: nil }
    end

    context 'when not signed in' do
      context 'upon successfully creating a new user' do
        before { post(:create, user: @new_user) }

        describe 'routes and responses' do
          it { should route(:post, '/users').to(action: :create) }
          it { should respond_with(:found) }
        end

        describe 'controller actions' do
          it 'should change the User count' do
            expect(User.count).to eql(1)
          end
          it { should redirect_to(user_url(User.last)) }
          it { should set_flash[:success] }
        end
      end

      context 'when unsuccessfully creating a new user' do
        before { post(:create, user: @bad_user) }

        describe 'controller actions' do
          it { should respond_with(:success) }
          it { should render_template(:new) }
          it { should_not set_flash } # caught by javascript on client side.
        end
      end
    end

    context 'when signed in' do
      before do
        @user = User.create(user_attributes)
        session[:user_id] = @user.id
        post(:create, user: @new_user)
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'GET :edit' do
    before { @user = User.create(user_attributes) }

    context 'when not signed in' do
      before do
        session[:user_id] = nil
        get :edit, id: @user.id
      end

      it_behaves_like 'a user not signed in'
    end

    context 'when signed in' do
      before do
        session[:user_id] = @user.id
        get :edit, id: @user.id
      end

      describe 'routes and responses' do
        it { should route(:get, '/users/1-Example-User/edit').to(action: :edit, id: '1-Example-User') }
        it { should respond_with(:success) }
        it { should render_with_layout(:application) }
        it { should render_template(:edit) }
        it { should_not set_flash }
      end
    end

    context 'when signed is as a different user' do
      before do
        @wrong_user = User.create!(wrong_user_attributes)
        session[:user_id] = @wrong_user.id
        get :edit, id: @user.id
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'PATCH :update' do
    before { @user = User.create(user_attributes) }

    context 'when not signed in' do
      before do
        session[:user_id] = nil
        patch(:update, id: @user.id, user: { name: 'Example Two User' })
      end

      it_behaves_like 'a user not signed in'
    end

    context 'when signed in as the current user' do
      before { session[:user_id] = @user.id }

      context 'when successfully updating a user' do
        before { patch(:update, id: @user.id, user: { email: 'change@example.com' }) }

        describe 'routes and responses' do
          it { should route(:patch, '/users/1-Example-User').to(action: :update, id: '1-Example-User') }
          it { should respond_with(:found) }
        end

        describe 'controller actions' do
          it 'should have the new email address in the database' do
            expect(@user.reload.email).to eql('change@example.com')
          end
          it { should redirect_to(@user) }
          it { should set_flash[:success] }
        end
      end

      context 'when unsuccessfully updating a user ' do
        before { patch(:update, id: @user.id, user: { email: '@example.com' }) }

        describe 'routes and responses' do
          it { should respond_with(:success) }
        end

        describe 'controller actions' do
          it { should render_template(:edit) }
          it { should_not set_flash } # caught by javascript on client side.
        end
      end
    end

    context 'when signed in as a different user' do
      before do
        @wrong_user = User.create!(wrong_user_attributes)
        session[:user_id] = @wrong_user.id
        patch(:update, id: @user.id, user: { name: 'Example Two User' })
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'DELETE :destroy' do
    before { @user = User.create!(user_attributes) }

    context 'when not signed in' do
      before do
        session[:user_id] = nil
        delete(:destroy, id: @user.id)
      end

      it_behaves_like 'a user not signed in'
    end

    context 'when signed in as the current user' do
      before { session[:user_id] = @user.id }

      context 'when successfully deleting a user' do
        before { delete(:destroy, id: @user.id) }

        describe 'routes and responses' do
          it { should route(:delete, '/users/1-Example-User').to(action: :destroy, id: '1-Example-User') }
          it { should respond_with(:found) }
        end

        describe 'controller actions' do
          it 'should remove the user from the database' do
            expect(User.count).to eql(0)
          end
          it { should redirect_to(root_url) }
          it { should_not set_flash }
        end
      end

      context 'when signed in as a different user' do
        before do
          @wrong_user = User.create!(wrong_user_attributes)
          session[:user_id] = @wrong_user.id
          delete(:destroy, id: @user.id)
        end

        it_behaves_like 'signed in as a different user'
      end
    end
  end

end

# TODO:  determine how to test collections.