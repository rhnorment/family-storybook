require 'rails_helper'

describe StorybooksController, type: :controller do

  before do
    @user = User.create!(user_attributes)

    @storybook = @user.storybooks.create!(storybook_attributes)
  end

  context 'when not signed in' do
    it 'cannot access index' do
      expect(get :index).to redirect_to(new_session_url)
    end

    it 'cannot access show' do
      expect(get :show, id: @storybook).to redirect_to(new_session_url)
    end

    it 'cannot access new' do
      expect(get :new).to redirect_to(new_session_url)
    end

    it 'cannot access create' do
      expect(post :create, id: @storybook).to redirect_to(new_session_url)
    end

    it 'cannot access edit' do
      expect(get :edit, id: @storybook).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      expect(patch :update, id: @storybook).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      expect(delete :destroy, id: @storybook).to redirect_to(new_session_url)
    end
  end

  context 'when signed in as the current user' do
    before do
      session[:user_id] = @user.id
    end

    it 'can access index'

    it 'can access show'

    it 'can access edit'

    it 'can access update'

    it 'can access destroy'

  end

  context 'when signed in as a user other than the current user' do
    before do
      @wrong_user = User.create!(user_attributes(email: 'wrong@example.com'))
      session[:user_id] = @wrong_user
    end

    it 'cannot access the show action of another uher' do
      expect(get :show, id: @storybook).to redirect_to(@wrong_user)
    end

    it 'cannot access new'

    it 'cannot access create'

    it 'cannot access edit' do
      expect(get :edit, id: @storybook).to redirect_to(new_session_url)
    end

    it 'cannot access update' do
      expect(patch :update, id: @storybook).to redirect_to(new_session_url)
    end

    it 'cannot access destroy' do
      expect(delete :destroy, id: @storybook).to redirect_to(new_session_url)
    end
  end







end