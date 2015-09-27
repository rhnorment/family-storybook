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
        expect(assigns(:invitees)).to include(user_4, user_5)
      end

      it 'does not assign the current user or current relatives as invitees' do
        expect(assigns(:invitees)).to_not include(user, user_2, user_3)
      end
    end
  end

  describe 'POST => :create' do
    let(:user)    { create(:user) }
    let(:user_2)  { create(:user, email: 'user_2@example.com') }
    let(:user_3)  { create(:user, email: 'user_3@example.com') }
    let(:user_4)  { create(:user, email: 'user_4@example.com') }
    let(:user_5)  { create(:user, email: 'user_5@example.com') }

    context 'when not signed in' do
      before { post(:create, user_id: user_4.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before { session_for_user }

      context 'when successfully inviting a user to become a family member' do
        before { post(:create, user_id: user_4.id) }

        it { should route(:post, '/relationships').to(action: :create) }
        it { should respond_with(:redirect) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:success] }

        it 'should create a new pending relationship' do
          expect(user.relationships.size).to eql(1)
        end
      end

      context 'when unsuccessfully inviting a user to become a family member' do
        before do
          user.invite(user_2)
          post(:create, user_id: user_2.id)
        end

        it { should route(:post, '/relationships').to(action: :create) }
        it { should respond_with(:redirect) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:danger] }

        it 'should not create a new pending relationsship' do
          expect(user.relationships.size).to eql(1)   # original relationship
        end
      end
    end
  end

  describe 'GET => :pending' do
    let(:user)    { create(:user) }
    let(:user_2)  { create(:user, email: 'user_2@example.com') }
    let(:user_3)  { create(:user, email: 'user_3@example.com') }
    let(:user_4)  { create(:user, email: 'user_4@example.com') }
    let(:user_5)  { create(:user, email: 'user_5@example.com') }

    context 'when not signed in' do
      before { get :pending }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before do
        session_for_user
        Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false)
        Relationship.create!(user_id: user.id, relative_id: user_3.id, pending: false)
        user.invite(user_4)
        user_5.invite(user)
        get :pending
      end

      it { should route(:get, '/relationships/pending').to(action: :pending) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:pending) }
      it { should_not set_flash }

      it 'assigns the page title' do
        expect(assigns(:page_title)).to eql('Pending invitations')
      end

      it 'assigns the pending relationships the user invited' do
        expect(assigns(:pending_invited)).to include(user_4)
      end

      it 'does not assign the current user or current relatives' do
        expect(assigns(:pending_invited)).to_not include(user, user_2, user_3)
        expect(assigns(:pending_invited_by)).to_not include(user, user_2, user_3)
      end

      it 'assigns the pending relationships the user has invited' do
        expect(assigns(:pending_invited_by)).to include(user_5)
      end
    end
  end

  describe 'PATCH => :update' do
    let(:user)    { create(:user) }
    let(:user_2)  { create(:user, email: 'user_2@example.com') }
    let(:user_3)  { create(:user, email: 'user_3@example.com') }

    before { user_2.invite(user) }

    context 'when not signed in' do
      before { patch(:update, id: user_2.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before { session_for_user }

      context 'when successfully approving a relationship' do
        before { patch(:update, id: user_2.id) }

        it { should route(:patch, "/relationships/#{user_2.id}").to(action: :update, id: user_2.id) }
        it { should respond_with(:redirect) }
        it { should redirect_to(pending_relationships_url) }
        it { should set_flash[:success]}

        it 'should create an approved relationship' do
          expect(user.relatives.size).to eql(1)
        end
      end

      context 'when unsuccessfully approving a relationship' do
        before { patch(:update, id: user_3.id) }

        it { should route(:patch, "/relationships/#{user_3.id}").to(action: :update, id: user_3.id) }
        it { should respond_with(:redirect) }
        it { should redirect_to(pending_relationships_url) }
        it { should set_flash[:danger]}

        it 'should create an approved relationship' do
          expect(user.relatives.size).to eql(0)
        end
      end
    end
  end

  describe 'DELETE => :destroy' do
    let(:user)    { create(:user) }
    let(:user_2)  { create(:user, email: 'user_2@example.com') }
    let(:user_3)  { create(:user, email: 'user_3@example.com') }

    before { Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false) }

    context 'when not signed in' do
      before { delete(:destroy, id: user_2.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before { session_for_user }

      context 'when successfully destroying a relationship' do
        before { delete(:destroy, id: user_2.id) }

        it { should route(:delete, "/relationships/#{user_2.id}").to(action: :destroy, id: user_2.id) }
        it { should respond_with(:redirect) }
        it { should redirect_to(relationships_url) }
        it { should set_flash[:warning] }

        it 'should destroy the relationship' do
          expect(user.relatives.size).to eql(0)
        end
      end

      context 'when unsuccessfully destroying a relationship' do
        before { delete(:destroy, id: user_3.id) }

        it { should route(:delete, "/relationships/#{user_3.id}").to(action: :destroy, id: user_3.id) }
        it { should respond_with(:redirect) }
        it { should redirect_to(relationships_url) }
        it { should set_flash[:danger] }

        it 'should destroy the relationship' do
          expect(user.relatives.size).to eql(1)
        end
      end
    end
  end

end