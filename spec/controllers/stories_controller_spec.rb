require 'rails_helper'

describe StoriesController, type: :controller do

  before do
    create_user
    create_user_stories
  end

  describe 'GET :index' do
    context 'user not signed in' do
      before do
        sign_out_current_user
        get :index
      end

      it_behaves_like 'user not signed in'
    end

    context 'signed in as current user' do
      before do
        sign_in_current_user
        get :index
      end

      it { should route(:get, '/stories').to(action: :index) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:index) }
      it { should_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('My stories')
      end

      it 'should correctly assign the story collection' do
        expect(assigns(:stories)).to include(@story_1, @story_2)
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

    context 'signed in as current user' do
      before do
        sign_in_current_user
        get :new
      end

      it { should route(:get, '/stories/new').to(action: :new) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:new) }
      it { should_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('Create a story')
      end

      it 'should be a new story object' do
        expect(assigns(:story)).to be_a_new(Story)
      end
    end
  end

  context 'POST :create' do
    before do
      @good_story = { title: 'Good Story', content: 'Good story content.' }
      @bad_story = { title: nil, content: nil }
    end

    context 'user not signed in' do
      before do
        sign_out_current_user
        post(:create, story: @good_story)
      end

      it_behaves_like 'user not signed in'
    end

    context 'signed in as current user' do
      before { sign_in_current_user }

      context 'when successfully creating a story' do
        before { post(:create, story: @good_story) }

        it { should route(:post, '/stories').to(action: :create) }
        it { should respond_with(:found) } # Why is this response????
        it { should redirect_to(Story.last) }  # Why does @good_story not work in this test???
        it { should set_flash[:success] }

        it 'should change the Story count' do
          expect(@user.stories.count).to eql(3) # 2 original stories + the new story.
        end
      end

      context 'when unsuccessfully creating a story' do
        before { post(:create, story: @bad_story) }

        it { should respond_with(:success) }  # Why is this the response?
        it { should render_template(:new) }
        it { should set_flash.now[:danger] }

        it 'should not change the Story count' do
          expect(@user.stories.count).to eql(2) # 2 original stories
        end
      end
    end
  end

  context 'GET :edit' do
    context 'user not signed in' do
      before do
        sign_out_current_user
        get :edit, id: @story_1.id
      end

      it_behaves_like 'user not signed in'
    end

    context 'signed in as current user' do

    end
  end

  context 'PATCH :update' do
    context 'user not signed in' do
      before do
        sign_out_current_user
        patch(:update, id: @story_1.id, story: { title: 'Title Change' })
      end

      it_behaves_like 'user not signed in'
    end

    context 'signed in as current user' do
      before { sign_in_current_user }

      context 'when successfully updating a story' do
        before { patch(:update, id: @story_1.id, story: { title: 'Title Change' }) }

        it { should route(:patch, '/stories/1').to(action: :update, id: '1') }
        it { should respond_with(:found) }
        it { should redirect_to(@story_1) }
        it { should set_flash[:success] }

        it 'should save the new title to the database' do
          expect(@story_1.reload.title).to eql('Title Change')
        end
      end

      context 'when unsuccessfully updating a story' do
        before { patch(:update, id: @story_1.id, story: { title: nil }) }

        it { should respond_with(:success) }
        it { should render_template(:edit) }
        it { should set_flash.now[:danger] }
      end
    end
  end

  context 'DELETE :destroy' do
    context 'user not signed in' do
      before do
        sign_out_current_user
        delete(:destroy, id: @story_2.id)
      end

      it_behaves_like 'user not signed in'
    end

    context 'signed in as current user' do
      before do
        sign_in_current_user
        delete(:destroy, id: @story_2.id)
      end

      it { should route(:delete, '/stories/2').to(action: :destroy, id: '2') }
      it { should respond_with(:found) }
      it { should redirect_to(stories_url) }
      it { should set_flash[:warning] }

      it 'should remove the story fron the database' do
        expect(@user.stories.count).to eql(1)  # 2 initial stories less the one destroyed.
      end
    end
  end

end