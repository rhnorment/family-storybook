# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  recipient_email :string(255)
#  token           :string(255)
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe Invitation, type: :model do

  it 'has a valid factory' do
    expect(build(:invitation)).to be_valid
  end

  context 'ActiveModel validations' do
    # basic validations:
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:recipient_email) }

    # format validations:
    it { should allow_value('recipient@example.com').for(:recipient_email) }
    it { should_not allow_value('@example.com', 'example.com').for(:recipient_email) }
  end

  describe 'ActiveRecord associations' do
    # database columns:
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:recipient_email).of_type(:string) }
    it { should have_db_column(:token).of_type(:string) }
    it { should have_db_column(:sent_at).of_type(:datetime) }
    it { should have_db_column(:accepted_at).of_type(:datetime) }

    it { should have_db_index(:user_id) }
    it { should have_db_index(:recipient_email) }
    it { should have_db_index(:token) }
    it { should have_db_index([:user_id, :recipient_email]).unique(:true) }

    # associations:
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
      it { should respond_to(:already_invited?) }
      it { should respond_to(:invited_self?) }
      it { should respond_to(:already_relatives_with?) }
      it { should respond_to(:recipient_is_member?) }
      it { should respond_to(:find_by_recipient_email) }
    end

    context 'executes methods correctly' do
      let(:invitation) { create(:invitation) }

      context '#create_invitation_digest' do
        it 'creates an token in the database before creation and saves it to the database' do
          expect(invitation.token.present?).to eql(true)
        end
      end

      context '#send_invitation_email' do
        it 'sends the email' do
          expect { invitation.send_invitation_email }.to change { ActionMailer::Base.deliveries.count }.by(2)
        end

        it 'updates the sent_at column' do
          expect(invitation.sent_at).to_not be_nil
        end
      end

      context '#already_invited?' do
        let(:invitation_already_sent) { create(:invitation_already_sent) }
        let(:valid_invitation) { build(:valid_invitation) }

        it 'returns true if the recipient email is found' do
          expect(invitation_already_sent.already_invited?).to eql(true)
        end

        it 'returns false if the recipient email is not found' do
          expect(valid_invitation.already_invited?).to eql(false)
        end
      end

      context '#invited_self?' do
        let(:user_as_self) { create(:user_as_self) }
        let(:invitation_to_self) { build(:invitation_to_self, user: user_as_self) }
        let(:valid_invitation) { build(:valid_invitation) }

        it 'returns true if the user is inviting himself' do
          expect(invitation_to_self.invited_self?).to eql(true)
        end

        it 'returns false if the user is not inviting himself' do
          expect(valid_invitation.invited_self?).to eql(false)
        end
      end

      context '#already_relatives_with?' do
        let(:user) { create(:user) }
        let(:relative) { create(:user_already_relative) }
        # Relationship.create!(user: user, relative: relative, pending: false)

        it 'returns true if the user is already relatives with the recipient'

        it 'returns false if the user it not relatives with the recipient'
      end

      context '#is_member?' do
        let(:user_is_member) { create(:user_as_member) }
        let(:invitation_to_member) { build(:invitation_to_member) }
        let(:valid_invitation) { build(:valid_invitation) }

        it 'returns true if the recipient is already a member' do
          expect(invitation_to_member.recipient_is_member?).to be(true)
        end

        it 'returns false if the recipient is not a member' do
          expect(valid_invitation.recipient_is_member?).to eql(false)
        end
      end

      context '#find_by_recipient_email' do
        let(:user_to_find) { create(:user_to_find) }
        let(:invitation) { build(:invitation, recipient_email: 'find_me@example.com') }

        it 'should find the member' do
          expect(invitation.find_by_recipient_email).to eql(user_to_find)
        end
      end
    end
  end

end