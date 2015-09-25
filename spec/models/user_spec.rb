# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  reset_token     :string
#  reset_sent_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  active          :boolean          default(FALSE)
#

require 'rails_helper'

describe User, type: :model do

  before { User.send(:public, *User.protected_instance_methods) }

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  let(:user) { create(:user) }

  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:email).of_type(:string) }
  it { is_expected.to have_db_column(:password_digest).of_type(:string) }
  it { is_expected.to have_db_column(:reset_token).of_type(:string) }
  it { is_expected.to have_db_column(:reset_sent_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:active).of_type(:boolean).with_options(default: false) }

  it { is_expected.to have_db_index(:email) }

  it { is_expected.to have_many(:storybooks).dependent(:destroy) }
  it { is_expected.to have_many(:stories).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it 'requires a password confirmation when the password is present' do
    expect(User.new(password: 'secret', password_confirmation: '')).to_not be_valid
  end

  it 'is invalid if the password and password confirmation do not match' do
    expect(User.new(password: 'secret', password_confirmation: 'wrong')).to_not be_valid
  end

  it 'does not require a password when updating' do
    user.password = ''

    expect(user).to be_valid
  end

  it { is_expected.to allow_value('user@example.com').for(:email) }
  it { is_expected.to_not allow_value('example.com', 'example.').for(:email) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:reset_token) }
  it { is_expected.to respond_to(:reset_sent_at) }
  it { is_expected.to respond_to(:gravatar_id) }

  it 'returns a digest to be used by the Gravatar web service' do
    expect(Digest::MD5.hexdigest(user.email.downcase)).to eql('b58996c504c5638798eb6b511e6f49af')
  end

  context 'module and mixin methods' do
    describe 'Account module' do
      it { is_expected.to respond_to(:activate) }
      it { is_expected.to respond_to(:deactivate) }
      it { is_expected.to respond_to(:is_active?) }
      it { is_expected.to respond_to(:is_inactive?) }
    end

    describe 'Authentication module' do
      it { is_expected.to have_secure_password }

      it { is_expected.to respond_to(:authenticate) }
    end

    describe 'Family module' do
      it { is_expected.to have_many(:invitations).dependent(:destroy) }
      it { is_expected.to have_many(:relationships).dependent(:destroy) }
      it { is_expected.to have_many(:inverse_relationships).dependent(:destroy) }

      it { is_expected.to respond_to(:invite) }
      it { is_expected.to respond_to(:approve) }
      it { is_expected.to respond_to(:create_relationship_from_invitation) }
      it { is_expected.to respond_to(:remove_relationship) }
      it { is_expected.to respond_to(:relatives) }
      it { is_expected.to respond_to(:total_relatives) }
      it { is_expected.to respond_to(:invitation_approved_on) }
      it { is_expected.to respond_to(:related_to?) }
      it { is_expected.to respond_to(:connected_with?) }
      it { is_expected.to respond_to(:prospective_relatives) }
      it { is_expected.to respond_to(:invitation_sent_on) }
      it { is_expected.to respond_to(:invited_by?) }
      it { is_expected.to respond_to(:invited?) }
      it { is_expected.to respond_to(:common_relatives_with) }
      it { is_expected.to respond_to(:find_any_relationship_with) }
    end

    describe 'PasswordReset module' do
      it { is_expected.to respond_to(:create_reset_digest) }
      it { is_expected.to respond_to(:send_password_reset_email) }
      it { is_expected.to respond_to(:password_reset_expired?) }
    end

    describe 'Trackable module' do
      it { is_expected.to have_one(:activity) }
    end
  end

end
