require 'rails_helper'

describe StorybooksController, type: :controller do

  describe 'GET :index' do
    let(:user)            { create(:user) }
    let(:wrong_user)      { create(:user, :wrong_user) }
    let(:storybook_1)     { create(:storybook, user: user) }
    let(:storybook_2)     { create(:storybook, user: user) }
    let(:wrong_storybook) { create(:storybook, user: wrong_user) }

    context 'user not signed in' do
      before { get :index }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { session_for_user }

      context 'requesting HTML format' do
        before { get :index }

        it { is_expected.to route(:get, '/storybooks').to(action: :index) }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_with_layout(:application) }
        it { is_expected.to render_template(:index) }
        it { is_expected.to_not set_flash }

        it 'should set the page title' do
          expect(assigns(:page_title)).to eql('My storybooks')
        end

        it 'should correctly assign the storybook collection' do
          expect(assigns(:storybooks)).to include(storybook_1, storybook_2)
        end

        it 'should correctly assign the storybook collection' do
          expect(assigns(:storybooks)).to_not include(wrong_storybook)
        end
      end

      describe 'requesting JSON format' do
        before { get(:index, format: :json) }

        it { is_expected.to route(:get, '/storybooks.json').to(action: :index, format: :json) }
        it { is_expected.to respond_with(:success) }

        it 'should retrieve JSON content type' do
          expect(response.header['Content-Type']).to include('application/json')
        end

        it 'includes titles'
      end
    end
  end

  describe 'GET => :show' do
    let(:user)      { create(:user) }
    let(:storybook) { create(:storybook, user: user) }

    context 'user not signed in' do
      before { get(:show, id: storybook.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before { session_for_user }

      describe 'requesting HTML format' do
        before { get(:show, id: storybook.id) }

        it { is_expected.to route(:get, "/storybooks/#{storybook.id}").to(action: :show, id: storybook.id) }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_with_layout(:application) }
        it { is_expected.to render_template(:show) }
        it { is_expected.to_not set_flash }

        it 'assigns the page title' do
          expect(assigns(:page_title)).to eql("Showing: #{storybook.title}")
        end
      end

      context 'requesting JSON format' do
        before { get(:show, id: storybook.id, format: :json) }

        it { is_expected.to route(:get, "/storybooks/#{storybook.id}.json").to(action: :show, id: storybook.id, format: :json) }
        it { is_expected.to respond_with(:success) }

        it 'should retrieve a JSON content type' do
          expect(response.content_type).to eql('application/json')
        end

        it 'should return the story by ID' do
          storybook_response = json(response.body)
          expect(storybook.title).to eql(storybook_response[:title])
        end
      end
    end

    context 'when signed in as a different user' do
      let(:user)            { create(:user) }
      let(:wrong_user)      { create(:user, :wrong_user) }
      let(:storybook)       { create(:storybook, user: user) }

      before do
        session_for_wrong_user
        get(:show, id: storybook.id)
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'GET => :new' do
    let(:user) { create(:user) }

    context 'user not signed in' do
      before { get(:new) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before do
        session_for_user
        get(:new)
      end

      it { is_expected.to route(:get, '/storybooks/new').to(action: :new) }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:application) }
      it { is_expected.to render_template(:new) }
      it { is_expected.to_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('Start a storybook')
      end

      it 'should be a new storybook object' do
        expect(assigns(:storybook)).to be_a_new(Storybook)
      end
    end
  end

  describe 'POST => :create' do
    let(:user)              { create(:user) }
    let(:valid_storybook)   { storybook_attributes }
    let(:invalid_storybook) { storybook_attributes(title: nil) }

    context 'user not signed in' do
      before { post(:create, storybook: valid_storybook) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { session_for_user }

      context 'successfully creates a new storybook' do
        before { post(:create, storybook: valid_storybook) }

        it { is_expected.to route(:post, '/storybooks').to(action: :create) }
        it { is_expected.to respond_with(:redirect) }
        it { is_expected.to redirect_to(Storybook.last) }
        it { is_expected.to set_flash[:success] }

        it 'should change the Storybook count' do
          expect(user.storybooks.count).to eql(1)
        end

      end

      context 'does not create a new storybook' do
        before { post(:create, storybook: invalid_storybook) }

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
        it { is_expected.to set_flash.now[:danger] }

        it 'should not change the Storybook count' do
          expect(user.storybooks.count).to eql(0)
        end
      end
    end
  end

  describe 'GET => :edit' do
    let(:user)      { create(:user) }
    let(:storybook) { create(:storybook, user: user) }

    context 'when not signed in' do
      before { get(:edit, id: storybook.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before do
        session_for_user
        get(:edit, id: storybook.id)
      end

      it { is_expected.to route(:get, "/storybooks/#{storybook.id}/edit").to(action: :edit, id: storybook.id) }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:application) }
      it { is_expected.to render_template(:edit) }
      it { is_expected.to_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql("Editing #{storybook.title}")
      end
    end
  end

  describe 'PATCH => :update' do
    let(:user)      { create(:user) }
    let(:storybook) { create(:storybook, user: user) }

    context 'when not signed in' do
      before { patch(:update, id: storybook.id, storybook: { title: 'Title Change' }) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { session_for_user }

      context 'when successfully updating a storybook' do
        before { patch(:update, id: storybook.id, storybook: { title: 'Title Change' }) }

        it { is_expected.to route(:patch, "/storybooks/#{storybook.id}").to(action: :update, id: storybook.id) }
        it { is_expected.to respond_with(:found) }
        it { is_expected.to redirect_to(storybook) }
        it { is_expected.to set_flash[:success] }

        it 'should save the new title in the database' do
          expect(storybook.reload.title).to eql('Title Change')
        end
      end

      context 'when unsucessfully updating a storybook' do
        before { patch(:update, id: storybook.id, storybook: { title: nil }) }

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
        it { is_expected.to set_flash.now[:danger] }
      end
    end
  end

  describe 'DELETE => :destroy' do
    let(:user)      { create(:user) }
    let(:storybook) { create(:storybook, user: user) }

    context 'when not signed in' do
      before { delete(:destroy, id: storybook.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        session_for_user
        delete(:destroy, id: storybook.id)
      end

      it { is_expected.to route(:delete, "/storybooks/#{storybook.id}").to(action: :destroy, id: storybook.id) }
      it { is_expected.to respond_with(:found) }
      it { is_expected.to redirect_to(storybooks_url) }
      it { is_expected.to set_flash[:warning] }

      it 'should remove the storybook from the database' do
        expect(user.storybooks.count).to eql(0)
      end
    end
  end

end