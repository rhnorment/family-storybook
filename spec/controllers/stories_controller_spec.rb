require 'rails_helper'

describe StoriesController, type: :controller do

  before do
    @user = User.create!(user_attributes)
    @story = @user.stories.create!(story_attributes)
  end

  context 'when not signed in' do
    it 'cannot access index' do
      expect(get :index).to redirect_to(new_session_url)
    end

    it 'cannot access show' do
      expect(get :show, id: @story).to redirect_to(new_session_url)
    end

    it 'cannot access new' do
      expect(get :new).to redirect_to(new_session_url)
    end

    it 'cannot access create' do
      expect(post :create, id: @story).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      expect(get :edit, id: @story).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      expect(patch :update, id: @story).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      expect(delete :destroy, id: @story).to redirect_to(new_session_url)
    end
  end

  context 'when signed in as the current user' do
    before do
      session[:user_id] = @user.id
      @new_story = { title: 'Test Story', content: nil }
    end

    it 'can access index' do
      expect(get :index).to render_template(:index)
    end

    it 'can access show' do
      expect(get :show, id: @story).to render_template(:show)
    end

    it 'can access new' do
      expect(get :new).to render_template(:new)
    end

    it 'can access create and create a storybook' do
      expect { post :create, story: @new_story }.to change(Story, :count).by(+1)
      expect(response).to redirect_to(story_url(Story.last))
    end

    it 'can access edit' do
      expect(get :edit, id: @story).to render_template(:edit)
    end

    it 'can access update' do
      expect {
        patch :update, id: @story.id, story: { title: 'Updated Test Title' }
        @story.reload
      }.to change(@story, :title).to('Updated Test Title')
      expect(response).to redirect_to(@story)
    end

    it 'can access destroy' do
      expect { delete :destroy, id: @story.id }.to change(Story, :count).by(-1)
      expect(response).to redirect_to(stories_url)
    end
  end

  context 'when signed in as a user other than the current user' do
    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user.id
    end

    it 'cannot access the show action of another user' do
      expect(get :show, id: @story).to redirect_to(@wrong_user)
    end

    it 'cannot access edit' do
      expect(get :edit, id: @story).to redirect_to(@wrong_user)
    end

    it 'cannot access update' do
      expect(patch :update, id: @story).to redirect_to(@wrong_user)
    end

    it 'cannot access destroy' do
      expect(delete :destroy, id: @story).to redirect_to(@wrong_user)
    end
  end

end