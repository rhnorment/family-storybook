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
    expect(build(:user_with_invitations)).to be_valid
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
      it { should respond_to(:find_member) }
      it { should respond_to(:already_invited?) }
      it { should respond_to(:send_invitation_email) }
    end

    context 'executes methods correctly' do
      context '#create_invitation_digest' do
        let(:invitation) { create(:invitation) }

        it 'creates an token in the database before creation and saves it to the database' do
          expect(invitation.token.present?).to eql(true)
        end
      end

      context '#find_member' do
        it 'finds a member if the recipient email belongs to a member' do
          member = create(:user, email: 'member@example.com')
          expect(User.find_by_email('member@example.com')).to eql(member)

        end
      end


    end
  end

end