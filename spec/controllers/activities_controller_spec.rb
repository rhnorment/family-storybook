require 'rails_helper'

describe ActivitiesController, type: :controller do

  describe 'GET :index' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :index }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        session_for_user
        get :index
      end

      it { should route(:get, '/activities').to(action: :index) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:index) }
      it { should_not set_flash }

      it 'should set the page title' do
        expect(assigns(:page_title)).to eql('My activities')
      end

      it 'should set the collection of user activities' do
        expect(assigns(:activities)).to include { Activity.where(owner_id: user.id) }
      end
    end
  end

end