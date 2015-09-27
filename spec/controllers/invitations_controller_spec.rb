require 'rails_helper'

describe InvitationsController, type: :controller do

  describe 'GET :new' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :new }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in' do
      before do
        session_for_user
        get :new
      end

      it { should route(:get, '/invitations/new').to(action: :new) }
      it { should respond_with(:success) }
      it { should render_with_layout(:application) }
      it { should render_template(:new) }
      it { should_not set_flash }
    end
  end

  describe 'POST => :create' do
    let(:user)              { create(:user) }
    let(:invited_user)      { create(:user, :invited_user) }
    let(:relative)          { create(:relative) }

    context 'when not signed in' do
      before { post(:create, recipient_email: 'recipient@example.com' ) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before { session_for_user }

      context 'when inviting a user that has already been invited' do
        before do
          user.invitations.create!(recipient_email: invited_user.email)
          post(:create, invitation: { recipient_email: 'invited_user@example.com' })
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:warning] }
      end

      context 'when inviting the current user' do
        before { post(:create, invitation: { recipient_email: 'user@example.com' }) }

        it { should respond_with(:redirect) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:warning] }
      end

      context 'when inviting a user that is already family member' do
        before do
          Relationship.create!(user_id: user.id, relative_id: relative.id, pending: false)
          post(:create, invitation: { recipient_email: 'relative@example.com' })
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(relationships_url) }
        it { should set_flash[:info] }
      end

      context 'when inviting a user that is already a member of the site' do
        before do
          create(:user, :member_user)
          post(:create, invitation: { recipient_email: 'member_user@example.com' })
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:info] }
      end

      context 'when successfully inviting a user' do
        before { post(:create, invitation: { recipient_email: 'recipient@example.com' }) }

        it { should route(:post, '/invitations').to(action: :create) }
        it { should respond_with(:found) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:success] }

        it 'should save the invitation in the database' do
          expect(user.invitations.count).to eql(1)
        end
      end

      context 'when entering an invalid email address' do
        before { post(:create, invitation: { recipient_email: 'example@' }) }

        it { should respond_with(:redirect) }
        it { should redirect_to(new_relationship_url) }
        it { should set_flash[:danger] }
      end
    end
  end

end