require 'rails_helper'

describe SearchController, type: :controller do

  before do
    @user = User.create!(user_attributes)
  end

  context 'when not signed in' do
    it 'cannot access search' do
      expect(get :search).to redirect_to(new_session_url)
    end
  end

  context 'when signed in' do
    it 'can access search' do
      session[:user_id] = @user.id

      expect(get :search).to render_template(:search)
    end
  end

end