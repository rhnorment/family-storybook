require 'rails_helper'

describe InvitationsController, type: :controller do

  before do
    @user = User.create!(user_attributes)
  end

  context 'when not signed in' do
    it 'cannot access new' do
      expect(get :new).to redirect_to(new_session_url)
    end
  end

  context 'when signed in' do
    before do
      session[:user_id] = @user.id
    end

    it 'can access new' do
      expect(get :new).to render_template(:new)
    end

    context 'when the invitation is valid' do
      it 'creates the invitation and redirects to new relationship' do
        expect { post :create, invitation: { recipient_email: 'valid_email@example.com' } }.to change(Invitation, :count).by(+1)
        expect(response).to redirect_to(new_relationship_url)
      end
    end

    context 'when the invitation is to the current user' do
      it 'does not create the invitation and redirects to new relationship' do
        expect { post :create, invitation: { recipient_email: @user.email } }.to_not change(Invitation, :count)
        expect(response).to redirect_to(new_relationship_url)
      end
    end

    context 'when the invitation is to a user that is already a relative' do
      it 'does not create the invitation and redirects to new relationship' do
        relative = User.create!(user_attributes(email: 'relative@example.com'))

        expect { post :create, invitation: { recipient_email: relative.email } }.to_not change(Invitation, :count)
        expect(response).to redirect_to(new_relationship_url)
      end
    end

    context 'when the invitation is to a user that has already been sent an invitation' do
      it 'does not create the invitation and redirects to new relationship' do
        invitee = Invitation.create!(user_id: @user.id, recipient_email: 'invitee@example.com')

        expect { post :create, invitation: { recipient_email: invitee.recipient_email } }.to_not change(Invitation, :count)
        expect(response).to redirect_to(new_relationship_url)
      end
    end

    context 'when the invitation is to a user that is already a member' do
      it 'does not create the invitation and redirects to new relationship' do
        member = User.create!(user_attributes(email: 'member@example.com'))

        expect { post :create, invitation: { recipient_email: member.email } }.to_not change(Invitation, :count)
        expect(response).to redirect_to(new_relationship_url)
      end
    end
  end

end