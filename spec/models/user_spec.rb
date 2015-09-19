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

  before do
    User.send(:public, *User.protected_instance_methods)
    @user = User.new(user_attributes)
  end

  it 'it valid with example attributes' do
    expect(User.new(user_attributes)).to be_valid
  end

  describe 'ActiveRecord columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_db_column(:reset_token).of_type(:string) }
    it { should have_db_column(:reset_sent_at).of_type(:datetime) }
    it { should have_db_column(:active).of_type(:boolean).with_options(default: false) }

    it { should have_db_index(:email) }
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:storybooks).dependent(:destroy) }
    it { should have_many(:stories).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    before { User.new }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }

    it 'requires a password confirmation when the password is present' do
      expect(User.new(password: 'secret', password_confirmation: '')).to_not be_valid
    end

    it 'is invalid if the password and password confirmation do not match' do
      expect(User.new(password: 'secret', password_confirmation: 'wrong')).to_not be_valid
    end

    it 'does not require a password when updating' do
      @user.password = ''

      expect(@user).to be_valid
    end

    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('example.com', 'example.').for(:email) }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { should respond_to(:name) }
      it { should respond_to(:email) }
      it { should respond_to(:reset_token) }
      it { should respond_to(:reset_sent_at) }
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:gravatar_id) }

      it 'returns a digest to be used by the Gravatar web service' do
        expect(Digest::MD5.hexdigest(@user.email.downcase)).to eql('b58996c504c5638798eb6b511e6f49af')
      end
    end
  end

  describe 'module and mixin methods' do
    before { create_user }

    describe 'Account module' do
      it { should respond_to(:activate) }
      it { should respond_to(:is_active?) }
      it { should respond_to(:is_inactive?) }
    end

    describe 'Authentication module' do
      it { should have_secure_password }

      it { should respond_to(:authenticate) }
    end

    describe 'Family module' do
      it { should have_many(:invitations).dependent(:destroy) }
      it { should have_many(:relationships).dependent(:destroy) }
      it { should have_many(:inverse_relationships).dependent(:destroy) }

      it { should respond_to(:invite) }
      it { should respond_to(:approve) }
      it { should respond_to(:create_relationship_from_invitation) }
      it { should respond_to(:remove_relationship) }
      it { should respond_to(:relatives) }
      it { should respond_to(:total_relatives) }
      it { should respond_to(:invitation_approved_on) }
      it { should respond_to(:related_to?) }
      it { should respond_to(:connected_with?) }
      it { should respond_to(:prospective_relatives) }
      it { should respond_to(:invitation_sent_on) }
      it { should respond_to(:invited_by?) }
      it { should respond_to(:invited?) }
      it { should respond_to(:common_relatives_with) }
      it { should respond_to(:find_any_relationship_with) }
    end

    describe 'PasswordReset module' do
      it { should respond_to(:create_reset_digest) }
      it { should respond_to(:send_password_reset_email) }
      it { should respond_to(:password_reset_expired?) }
    end

    describe 'Trackable module' do
      it { should have_one(:activity) }
    end
  end

end
