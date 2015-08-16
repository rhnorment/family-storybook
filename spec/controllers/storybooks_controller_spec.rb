require 'rails_helper'

describe StorybooksController, type: :controller do

  describe 'GET :index' do
    context 'user not signed in' do
      before { get :index }

      it 'should have as user not signed in'
    end

    context 'when signed in as current user' do
      before do
        create_and_sign_in_current_user
        get :index
      end
      describe 'routes and responses' do

      end

      describe 'variables and actions' do

      end
    end

    context 'when signed in as different user' do
      before do
        create_and_sign_in_wrong_user
        get :index
      end

    end


  end


end