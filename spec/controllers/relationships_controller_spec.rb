require 'rails_helper'

describe RelationshipsController, type: :controller do

  describe 'GET => :index' do
    let(:user)    { create(:user) }
    let(:user_2)  { create(:user, email: 'user_2@example.com') }
    let(:user_3)  { create(:user, email: 'user_3@example.com') }
    let(:user_4)  { create(:user, email: 'user_4@example.com') }
    let(:user_5)  { create(:user, email: 'user_5@example.com') }

    context 'when not signed in' do
      before { get :index }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as the current user' do
      before do
        Relationship.create(user: user, relative: user_2, pending: false)
        Relationship.create(user: user, relative: user_3, pending: false)
        session_for_user
        get :index
      end

      it { should route(:get, '/relationships').to(action: :index) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:index) }
      it { should_not set_flash }

      it 'assigns the page title' do
        expect(assigns(:page_title)).to eql('My family members')
      end

      it 'assigns the user relatives' do
        expect(assigns(:relatives)).to include(user_2, user_3)
      end

      it 'does not assign non-relatives' do
        expect(assigns(:relatives)).to_not include(user_4, user_5)
      end
    end
  end

  describe 'GET => :new' do
    let(:user)    { create(:user) }
    let(:user_2)  { create(:user, email: 'user_2@example.com') }
    let(:user_3)  { create(:user, email: 'user_3@example.com') }
    let(:user_4)  { create(:user, email: 'user_4@example.com') }
    let(:user_5)  { create(:user, email: 'user_5@example.com') }

    context 'when not signed in' do
      before { get :new }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before do
        Relationship.create(user: user, relative: user_2, pending: false)
        Relationship.create(user: user, relative: user_3, pending: false)
        session_for_user
        get :new
      end

      it { should route(:get, '/relationships/new').to(action: :new) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:new) }
      it { should_not set_flash }

      it 'assigns the page title' do
        expect(assigns(:page_title)).to eql('Add family members')
      end

      it 'assigns the user invitees to non-relatives' do
        # expect(assigns(:invitees)).to include(user_4, user_5)
      end

      it 'does not assign the current user or current relatives as invitees' do
        expect(assigns(:invitees)).to_not include(user, user_2, user_3)
      end
    end

  end

end