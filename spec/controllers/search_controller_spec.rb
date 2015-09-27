require 'rails_helper'

describe SearchController, type: :controller do

  describe 'SEARCH :search' do
    let(:user) { create(:user) }

    context 'user not signed in' do
      before { get :search }

      it_behaves_like 'user not signed in'
    end

    context 'sign in as the current user' do
      before do
        session_for_user
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