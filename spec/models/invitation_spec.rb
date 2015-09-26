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

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:recipient_email) }

  it { should allow_value('recipient@example.com').for(:recipient_email) }
  it { should_not allow_value('@example.com', 'example.com').for(:recipient_email) }

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

  it { should callback(:create_invitation_digest).before(:create) }
  it { should callback(:send_invitation_email).after(:create) }

  it { should respond_to(:user_id) }
  it { should respond_to(:recipient_email) }
  it { should respond_to(:token) }
  it { should respond_to(:sent_at) }
  it { should respond_to(:accepted_at) }

  it { should respond_to(:create_invitation_digest) }
  it { should respond_to(:send_invitation_email) }
  it { should respond_to(:invited_self?) }
  it { should respond_to(:already_relatives_with?) }
  it { should respond_to(:recipient_is_member?) }
  it { should respond_to(:find_by_recipient_email) }
  it 'should respond to pending?'
  it 'should respond to accepted?'

end
