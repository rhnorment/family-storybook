require 'rails_helper'

describe StorybooksController, type: :controller do

  describe 'GET :index' do
    context 'user not signed in' do
      before { get :index }

      it_behaves_like 'user not signed in'
    end
  end

end