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
      it { should respond_to(:is_member?) }
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
        it 'returns true if the recipient email is found'

        it 'returns false if the recipient email is not found'
      end

      context '#invited_self' do
        it 'returns true if the user is inviting himself'

        it 'returns false if the user is not inviting himself'
      end

      context '#already_relatives_with?' do
        it 'returns true if the user is already relatives with the recipient'

        it 'returns false if the user it not relatives with the recipient'
      end

      context '#is_member?' do
        it 'returns true if the recipient is already a member'

        it 'returns false if the recipient is not a member'
      end

      context 'find_member' do
        it 'finds a member if the recipient email belongs to a member' do
          member = create(:user, email: 'member@example.com')
          expect(User.find_by_email('member@example.com')).to eql(member)
        end
      end


    end
  end

end