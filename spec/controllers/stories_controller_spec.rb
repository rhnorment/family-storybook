require 'rails_helper'

describe StoriesController, type: :controller do

  describe 'GET => :index' do
    let(:user)        { create(:user) }
    let(:wrong_user)  { create(:user, :wrong_user) }
    let(:story_1)     { create(:story, user: user) }
    let(:story_2)     { create(:story, user: user) }
    let(:wrong_story) { create(:story, user: wrong_user) }

    context 'user not signed in' do
      before { get :index }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { session_for_user }

      context 'requesting HTML format' do
        before { get :index }

        it { is_expected.to route(:get, '/stories').to(action: :index) }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_with_layout(:application) }
        it { is_expected.to render_template(:index) }
        it { is_expected.to_not set_flash }

        it 'should set the page title' do
          expect(assigns(:page_title)).to eql('My stories')
        end

        it 'should correctly assign the story collection' do
          expect(assigns(:stories)).to include(story_1, story_2)
        end

        it 'should correctly assign the story collection' do
          expect(assigns(:stories)).to_not include(wrong_story)
        end
      end
    end
  end

  describe 'GET => :show' do
    let(:user)        { create(:user) }
    let(:wrong_user)  { create(:user, :wrong_user) }
    let(:story)       { create(:story, user: user) }

    context 'user not signed in' do
      before { get(:show, id: story.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before { session_for_user }

      describe 'requesting HTML format' do
        before { get(:show, id: story.id) }

        it { is_expected.to route(:get, "/stories/#{story.id}").to(action: :show, id: story.id) }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_with_layout(:application) }
        it { is_expected.to render_template(:show) }
        it { is_expected.to_not set_flash }

        it 'assigns the page title' do
          expect(assigns(:page_title)).to eql("Showing: #{story.title}")
        end
      end

      context 'requesting JSON format' do
        before { get(:show, id: story.id, format: :json) }

        it { is_expected.to route(:get, "/stories/#{story.id}.json").to(action: :show, id: story.id, format: :json) }
        it { is_expected.to respond_with(:success) }

        it 'should retrieve a JSON content type' do
          expect(response.content_type).to eql('application/json')
        end

        it 'should return the story by ID' do
          story_response = json(response.body)
          expect(story.title).to eql(story_response[:title])
        end
      end
    end

    context 'when signed in as a different user' do
      before do
        session_for_wrong_user
        get(:show, id: story.id)
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

      it { is_expected.to route(:get, '/stories/new').to(action: :new) }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:application) }
      it { is_expected.to render_template(:new) }
      it { is_expected.to_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('Write a story')
      end

      it 'should be a new story object' do
        expect(assigns(:story)).to be_a_new(Story)
      end
    end
  end

  describe 'POST => :create' do
    let(:user)          { create(:user) }
    let(:valid_story)   { story_attributes }
    let(:invalid_story) { story_attributes(title: nil) }

    context 'user not signed in' do
      before { post(:create, story: valid_story) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { session_for_user }

      context 'successfully creates a new story' do
        before { post(:create, story: valid_story) }

        it { is_expected.to route(:post, '/stories').to(action: :create) }
        it { is_expected.to respond_with(:redirect) }
        it { is_expected.to redirect_to(Story.last) }
        it { is_expected.to set_flash[:success] }

        it 'should change the story count' do
          expect(user.stories.count).to eql(1)
        end

      end

      context 'does not create a new story' do
        before { post(:create, story: invalid_story) }

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
        it { is_expected.to set_flash.now[:danger] }

        it 'should not change the story count' do
          expect(user.stories.count).to eql(0)
        end
      end
    end
  end

  describe 'GET => :edit' do
    let(:user)  { create(:user) }
    let(:story) { create(:story, user: user) }

    context 'when not signed in' do
      before { get(:edit, id: story.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before do
        session_for_user
        get(:edit, id: story.id)
      end

      it { is_expected.to route(:get, "/stories/#{story.id}/edit").to(action: :edit, id: story.id) }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_with_layout(:application) }
      it { is_expected.to render_template(:edit) }
      it { is_expected.to_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql("Editing #{story.title}")
      end
    end
  end

  describe 'PATCH => :update' do
    let(:user)  { create(:user) }
    let(:story) { create(:story, user: user) }

    context 'when not signed in' do
      before { patch(:update, id: story.id, story: { title: 'Title Change' }) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      before { session_for_user }

      context 'when successfully updating a story' do
        before { patch(:update, id: story.id, story: { title: 'Title Change' }) }

        it { is_expected.to route(:patch, "/stories/#{story.id}").to(action: :update, id: story.id) }
        it { is_expected.to respond_with(:found) }
        it { is_expected.to redirect_to(story) }
        it { is_expected.to set_flash[:success] }

        it 'should save the new title in the database' do
          expect(story.reload.title).to eql('Title Change')
        end
      end

      context 'when unsucessfully updating a story' do
        before { patch(:update, id: story.id, story: { title: nil }) }

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
        it { is_expected.to set_flash.now[:danger] }
      end
    end
  end

  describe 'DELETE => :destroy' do
    let(:user)  { create(:user) }
    let(:story) { create(:story, user: user) }

    context 'when not signed in' do
      before { delete(:destroy, id: story.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        session_for_user
        delete(:destroy, id: story.id)
      end

      it { is_expected.to route(:delete, "/stories/#{story.id}").to(action: :destroy, id: story.id) }
      it { is_expected.to respond_with(:found) }
      it { is_expected.to redirect_to(stories_url) }
      it { is_expected.to set_flash[:warning] }

      it 'should remove the story from the database' do
        expect(user.stories.count).to eql(0)
      end
    end
  end

end