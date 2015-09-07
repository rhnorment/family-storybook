require 'rails_helper'

describe StorybooksController, type: :controller do

  before  do
    create_user
    create_user_storybooks
  end

  describe 'GET :index' do
    context 'user not signed in' do
      before do
        sign_out_current_user
        get :index
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before { sign_in_current_user }

      context 'when requesting HTML format' do
        before do
          get :index
        end

        it { should route(:get, '/storybooks').to(action: :index) }
        it { should respond_with(:success) }
        it { should render_with_layout(:application) }
        it { should render_template(:index) }
        it { should_not set_flash }

        it 'should set the page title' do
          expect(assigns(:page_title)).to eql('My storybooks')
        end

        it 'should correctly assign the storybook collection' do
          expect(assigns(:storybooks)).to include(@storybook_1, @storybook_2)
        end
      end

      context 'when requesting JSON content type' do
        before { get(:index, format: :json) }

        it { should route(:get, '/storybooks.json').to(action: :index, format: :json) }
        it { should respond_with(:success) }

        it 'should retrieve JSON content type' do
          expect(response.header['Content-Type']).to include('application/json')
        end

        it 'should include the user storybooks in the response body' do
          storybooks = json(response.body)
          titles = storybooks.map { |s| s[:title] }
          expect(titles).to include('Storybook Title', 'Storybook Two Title')
        end
      end
    end

    context 'when signed in as a different user' do
      before do
        create_and_sign_in_wrong_user
        get(:show, id: @storybook_1.id)
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'GET :show' do
    context 'user not signed in' do
      before { get(:show, id: @storybook_1.id) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { sign_in_current_user }

      context 'requesting HTML format' do
        before { get( :show, id: @storybook_1.id) }

        it { should route(:get, '/storybooks/1').to(action: :show, id: '1') }
        it { should respond_with(:success) }
        it { should render_with_layout(:application) }
        it { should render_template(:show) }
        it { should_not set_flash }

        it 'assigns the page title' do
          expect(assigns(:page_title)).to eql('Showing: Storybook Title')
        end
      end

      context 'requesting JSON format' do
        before { get(:show, id: @storybook_1.id, format: :json) }

        it { should route(:get, '/storybooks/1.json').to(action: :show, id: '1', format: :json) }
        it { should respond_with(:success) }

        it 'should retrieve a JSON content type' do
          expect(response.content_type).to eql('application/json')
        end

        it 'should return the story by ID' do
          storybook = json(response.body)
          expect(@storybook_1.title).to eql(storybook[:title])
        end
      end
    end

  end

  describe 'GET :new' do
    context 'user not signed in' do
      before do
        sign_out_current_user
        get :new
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before do
        sign_in_current_user
        get :new
      end

      it { should route(:get, '/storybooks/new').to(action: :new) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:new) }
      it { should_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('Start a storybook')
      end

      it 'should be a new storybook object' do
        expect(assigns(:storybook)).to be_a_new(Storybook)
      end
    end
  end

  describe 'POST :create' do
    before do
      @good_storybook = { title: 'Good Storybook', description: 'Good storybook description' }
      @bad_storybook = { title: nil, description: nil }
    end

    context 'user not signed in' do
      before do
        sign_out_current_user
        post(:create, storybook: @good_storybook)
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before do
        sign_in_current_user
      end

      context 'when successfully creating a new storybook' do
        before { post(:create, storybook: @good_storybook) }

        it { should route(:post, '/storybooks').to(action: :create) }
        it { should respond_with(:found) }
        it { should redirect_to(Storybook.last) }
        it { should set_flash[:success] }

        it 'should change the Storybook count' do
          expect(@user.storybooks.count).to eql(3) # 2 original books + new book
        end
      end

      context 'when unsuccessfully creating a new storybook' do
        before { post(:create, storybook: @bad_storybook) }

        it { should respond_with(:success) }
        it { should render_template(:new) }
        it { should set_flash.now[:danger] }

        it 'should not change the Storybook count' do
          expect(@user.storybooks.count).to eql(2)  # 2 original stories.
        end
      end
    end
  end

  describe 'GET :edit' do
    context 'when not signed in' do
      before do
        sign_out_current_user
        get(:edit, id: @storybook_1.id)
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        sign_in_current_user
        get(:edit, id: @storybook_1.id)
      end

      it { should route(:get, '/storybooks/1/edit').to(action: :edit, id: '1') }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:edit) }
      it { should_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('Editing Storybook Title')
      end
    end
  end

  describe 'PATCH :update' do
    context 'when not signed in' do
      before do
        sign_out_current_user
        patch(:update, id: @storybook_1.id, storybook: { title: 'Title Change' })
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before { sign_in_current_user }

      context 'when successfully updating a storybook' do
        before { patch(:update, id: @storybook_1.id, storybook: { title: 'Title Change' }) }

        it { should route(:patch, '/storybooks/1').to(action: :update, id: '1') }
        it { should respond_with(:found) }
        it { should redirect_to(@storybook_1) }
        it { should set_flash[:success] }

        it 'should save the new title in the database' do
          expect(@storybook_1.reload.title).to eql('Title Change')
        end
      end

      context 'when unsucessfully updating a storybook' do
        before { patch(:update, id: @storybook_1.id, storybook: { title: nil }) }

        it { should respond_with(:success) }
        it { should render_template(:edit) }
        it { should set_flash.now[:danger] }
      end
    end
  end

  describe 'DELETE :destroy' do
    context 'when not signed in' do
      before do
        sign_out_current_user
        delete(:destroy, id: @storybook_2.id)
      end

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before  do
        sign_in_current_user
        delete(:destroy, id: @storybook_2.id)
      end

      it { should route(:delete, '/storybooks/2').to(action: :destroy, id: '2') }
      it { should respond_with(:found) }
      it { should redirect_to(storybooks_url) }
      it { should set_flash[:warning] }

      it 'should remove the user from the database' do
        expect(@user.storybooks.count).to eql(1) # 2 initial books less the one just destroyed.
      end
    end
  end

end