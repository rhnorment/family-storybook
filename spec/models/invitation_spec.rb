# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  recipient_email :string           not null
#  token           :string
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe Invitation, type: :model do

  before { Invitation.send(:public, *Invitation.protected_instance_methods) }

  it 'has a valid factory' do
    expect(build(:invitation)).to be_valid
  end

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:recipient_email) }

  it { is_expected.to allow_value('recipient@example.com').for(:recipient_email) }
  it { is_expected.to_not allow_value('@example.com', 'example.com').for(:recipient_email) }

  it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  it { is_expected.to have_db_column(:recipient_email).of_type(:string) }
  it { is_expected.to have_db_column(:token).of_type(:string) }
  it { is_expected.to have_db_column(:sent_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:accepted_at).of_type(:datetime) }

  it { is_expected.to have_db_index(:user_id) }
  it { is_expected.to have_db_index(:recipient_email) }
  it { is_expected.to have_db_index(:token) }
  it 'is_expected.to have db column pending'

  it { is_expected.to have_db_index([:user_id, :recipient_email]).unique(:true) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to callback(:create_invitation_digest).before(:create) }
  it { is_expected.to callback(:send_invitation_email).after(:create) }

  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:recipient_email) }
  it { is_expected.to respond_to(:token) }
  it { is_expected.to respond_to(:sent_at) }
  it { is_expected.to respond_to(:accepted_at) }

  it { is_expected.to respond_to(:create_invitation_digest) }
  it { is_expected.to respond_to(:send_invitation_email) }
  it { is_expected.to respond_to(:invited_self?) }
  it { is_expected.to respond_to(:already_relatives_with?) }
  it { is_expected.to respond_to(:recipient_is_member?) }
  it { is_expected.to respond_to(:find_by_recipient_email) }
  it 'should respond to pending?'
  it 'should respond to accepted?'

end
