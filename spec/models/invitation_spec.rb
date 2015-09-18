# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  recipient_email :string
#  token           :string
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe Invitation, type: :model do

  before do
    Invitation.send(:public, *Invitation.protected_instance_methods)
    create_user
  end

  it 'is valid with example attributes' do
    expect(@user.invitations.new(invitation_attributes)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:recipient_email) }

    it { should allow_value('recipient@example.com').for(:recipient_email) }
    it { should_not allow_value('@example.com', 'example.com').for(:recipient_email) }
  end

  describe 'ActiveRecord associations' do
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:recipient_email).of_type(:string) }
    it { should have_db_column(:token).of_type(:string) }
    it { should have_db_column(:sent_at).of_type(:datetime) }
    it { should have_db_column(:accepted_at).of_type(:datetime) }

    it { should have_db_index(:user_id) }
    it { should have_db_index(:recipient_email) }
    it { should have_db_index(:token) }
    it 'should have db column pending'

    it { should have_db_index([:user_id, :recipient_email]).unique(:true) }

    it { should belong_to(:user) }
  end

  describe 'callbacks' do
    it { should callback(:create_invitation_digest).before(:create) }
    it { should callback(:send_invitation_email).after(:create) }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { should respond_to(:user_id) }
      it { should respond_to(:recipient_email) }
      it { should respond_to(:token) }
      it { should respond_to(:sent_at) }
      it { should respond_to(:accepted_at) }
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:create_invitation_digest) }
      it { should respond_to(:send_invitation_email) }
      it { should respond_to(:invited_self?) }
      it { should respond_to(:already_relatives_with?) }
      it { should respond_to(:recipient_is_member?) }
      it { should respond_to(:find_by_recipient_email) }
      it 'should respond to pending?'
      it 'should respond to accepted?'
    end

    context 'executes methods correctly' do
      before do
        @member = User.create!(user_attributes(email: 'member@example.com'))
        @member_invitation = @user.invitations.new(invitation_attributes(recipient_email: 'member@example.com'))
        @saved_invitation = @user.invitations.create!(invitation_attributes(recipient_email: 'saved@example.com'))
        @valid_invitation = @user.invitations.new(invitation_attributes)
      end

      context '#create_invitation_digest' do
        it 'creates an token in the database before creation and saves it to the database' do
          expect(@saved_invitation.token.present?).to eql(true)
        end
      end

      context '#send_invitation_email' do
        it 'sends the invitation email' do
          expect { @saved_invitation.send_invitation_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'updates the sent_at column' do
          expect(@saved_invitation.sent_at).to_not be_nil
        end
      end

      context '#already_invited?' do
        before do
          @old_invitation = @user.invitations.create!(invitation_attributes(recipient_email: 'old_invite@example.com'))
        end

        it 'returns true if an invitation is found' do
          invitation = @user.invitations.new(invitation_attributes(recipient_email: 'saved@example.com'))
          expect(Invitation.invitation_exists?(@user, invitation.recipient_email)).to eql(true)
        end

        it 'returns false if an invitation is not found' do
          expect(Invitation.invitation_exists?@user, @valid_invitation.recipient_email).to eql(false)
        end
      end

      context '#invited_self?' do
        it 'returns true if the user is inviting himself' do
          invitation = @user.invitations.new(invitation_attributes(recipient_email: 'user@example.com'))
          expect(invitation.invited_self?).to eql(true)
        end

        it 'returns false if the user is not inviting himself' do
          expect(@valid_invitation.invited_self?).to eql(false)
        end
      end

      context '#already_relatives_with?' do
        before do
          relative = User.create!(user_attributes(email: 'relative@example.com'))
          Relationship.create(user_id: @user.id, relative_id: relative.id, pending: false)
        end

        it 'returns true if the user is already relatives with the recipient' do
          invitation = @user.invitations.new(invitation_attributes(recipient_email: 'relative@example.com'))
          expect(invitation.already_relatives_with?).to eql(true)
        end

        it 'returns false if the user it not relatives with the recipient' do
          expect(@valid_invitation.already_relatives_with?).to eql(false)
        end
      end

      context '#recipient_is_member?' do
        it 'returns true if the recipient is already a member' do
          expect(@member_invitation.recipient_is_member?).to eql(true)
        end

        it 'returns false if the recipient is not a member' do
          expect(@valid_invitation.recipient_is_member?).to eql(false)
        end
      end

      context '#find_by_recipient_email' do
        it 'should find the member' do
          expect(@member_invitation.find_by_recipient_email).to eql(@member)
        end
      end
    end
  end

end
