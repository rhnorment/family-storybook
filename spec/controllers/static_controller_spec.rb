require 'rails_helper'

describe StaticController, type: :controller do

  context 'when not signed in' do
    it 'uses the static layout' do
      expect(get :home).to render_template('layouts/static')
    end

    it 'can access home' do
      expect(get :home).to render_template :home
    end

    it 'can access how' do
      expect(get :how).to render_template :how
    end

    it 'can access showcase' do
      expect(get :showcase).to render_template :showcase
    end
  end

  context 'when signed in' do
    before do
      @user = User.create!(user_attributes)
      session[:user_id] = @user.id
    end

    it 'cannot access home' do
      expect(get :home).to redirect_to(@user)
    end

    it 'cannot access how' do
      expect(get :how).to redirect_to(@user)
    end

    it 'cannot access showcase' do
      expect(get :showcase).to redirect_to(@user)
    end
  end

end