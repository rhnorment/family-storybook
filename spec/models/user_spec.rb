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

  context 'when creating and editing a user' do
    it 'it has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }

    it 'is invalid without a valid email address' do
      expect(build(:user, email: 'example.com')).to_not be_valid
    end

    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:password) }

    it 'requires a password confirmation when the password is present' do
      expect(User.new(password: 'secret', password_confirmation: '')).to_not be_valid
    end

    it 'is invalid if the password and password confirmation do not match' do
      should have_secure_password
    end

    it 'does not require a password when updating' do
      user = build(:user)
      user.password = ''
      expect(user).to be_valid
    end

    it 'automatically encrypts the password into the password_digest attribute' do
      should have_secure_password
    end
  end

  context 'when authenticating a user' do
    before { @user = create(:user) }

    it 'returns not true if the email does not match' do
      expect(User.authenticate('norment@gmail.com', @user.email)).to_not eql(true)
    end

    it 'returns not true if the password does not match' do
      expect(User.authenticate('nomatch', @user.password)).to_not eql(true)
    end

    it 'returns the user if the email and password match' do
      expect(User.authenticate(@user.email, @user.password)).to eql(@user)
    end
  end

  context 'when dealing with database associations' do
    it { should have_many(:storybooks).dependent(:destroy) }

    it { should have_many(:stories).dependent(:destroy) }

    it { should have_many(:activities).dependent(:destroy) }

    it { should have_many(:invitations).dependent(:destroy) }

    it { should have_many(:relationships).dependent(:destroy) }

    it { should have_many(:inverse_relationships).dependent(:destroy) }
  end

end