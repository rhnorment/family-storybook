require 'rails_helper'

describe ActivitiesController, type: :controller do

  before do
    @user = User.create!(user_attributes)
  end

  context 'when not signed in' do
    it 'cannot access index' do
      session[:user_id] = nil

      expect(get :index).to redirect_to(new_session_url)
    end
  end

  context 'when signed in as current user' do
    it 'can access index' do
      session[:user_id] = @user.id

      expect(get :index).to render_template(:index)
    end
  end

end