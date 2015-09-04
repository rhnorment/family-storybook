require 'rails_helper'

describe SearchController, type: :controller do

  before do
    create_user
  end

  describe 'SEARCH :search' do
    context 'user not signed in' do
      before do
        get :search
      end

      it_behaves_like 'user not signed in'
    end

    context 'sign in as the current user' do
      before do
        sign_in_current_user
        get :search
      end

      it { should route(:get, '/search').to(action: :search) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:search) }
      it { should_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('Search results')
      end
    end
  end

end