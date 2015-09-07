# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  reset_token     :string(255)
#  reset_sent_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime

require 'rails_helper'

describe User, type: :model do

  before { User.send(:public, *User.protected_instance_methods) }

  it 'it valid with example attributes' do
    expect(User.new(user_attributes)).to be_valid
  end

  before do
    @user = User.new(user_attributes)
  end

  describe 'ActiveModel validations' do
    # basic validations:
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }

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

    # format validations:
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('example.com', 'example.').for(:email) }
  end

  describe 'ActiveRecord associations' do
    # database columns / indexes
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_db_column(:reset_token).of_type(:string) }
    it { should have_db_column(:reset_sent_at).of_type(:datetime) }

    it { should have_db_index(:email) }

    # associations:
    it { should have_many(:storybooks).dependent(:destroy) }
    it { should have_many(:stories).dependent(:destroy) }
    it { should have_many(:activities).dependent(:destroy) }
    it { should have_many(:invitations).dependent(:destroy) }
    it { should have_many(:relationships).dependent(:destroy) }
    it { should have_many(:inverse_relationships).dependent(:destroy) }
  end

  context 'callbacks' do
    it { should callback(:send_activation_email).after(:create) }
    it { should callback(:create_activity).after(:create) }
    it { should callback(:remove_activities).before(:destroy) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:send_activation_email) }
      it { should respond_to(:create_activity) }
      it { should respond_to(:remove_activities) }
      it { should respond_to(:gravatar_id) }
    end

    context 'executes methods correctly' do
      context '#send_activation_email' do
        it 'sends the email' do
          expect { @user.send_activation_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context '#create_activity' do
        it 'should create an activity when it is created' do
          expect(@user.activities.last).to eql(PublicActivity::Activity.last)
        end
      end

      context '#remove_activities' do
        it 'should remove all activities associated with the user' do
          user = User.create!(user_attributes)
          user.storybooks.create!(storybook_attributes)
          user.stories.create!(story_attributes)

          user.destroy

          expect(PublicActivity::Activity.count).to eql(0)
        end
      end

      context '#gravatar_id' do
        it 'returns a digest to be used by the Gravatar web service' do
          expect(Digest::MD5.hexdigest(@user.email.downcase)).to eql('b58996c504c5638798eb6b511e6f49af')
        end
      end
    end
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { should respond_to(:name) }
      it { should respond_to(:email) }
      it { should respond_to(:reset_token) }
      it { should respond_to(:reset_sent_at) }
    end
  end

end