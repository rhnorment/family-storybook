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

    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:user, name: nil)).to_not be_valid
    end

    it 'is invalid without an email' do
      expect(build(:user, email: nil)).to_not be_valid
    end

    it 'is invalid without a valid email address' do
      expect(build(:user, email: 'example.com')).to_not be_valid
    end

    it 'is invalid without a unique, case sensitive email address' do
      user1 = create(:user, email: 'test@example.com')
      user2 = build(:user, email: user1.email)
      expect(user2).to_not be_valid
      expect(user2.errors[:email].first).to eql('has already been taken')
    end

    it 'is invalid without a password' do
      expect(build(:user, password: nil)).to_not be_valid
    end

    it 'requires a password confirmation when the password is present' do
      expect(build(:user, password: 'secret', password_confirmation: '')).to_not be_valid
    end

    it 'is invalid if the password and password confirmation do not match' do
      expect(build(:user, password: 'secret', password_confirmation: 'nomatch')).to_not be_valid
    end

    it 'does not require a password when updating' do
      user = create(:user)
      user.password = ''
      expect(user).to be_valid
    end

    it 'automatically encrypts the password into the password_digest attribute' do
      user = build(:user)
      expect(user.password_digest.present?).to eql(true)
    end

  end

  context 'when authenticating a user' do

    it 'returns false if the email is not found'

    it 'returns false if the password does not match'

    it 'returns the user if the email and password match'

  end

  context 'when dealing with associated storybooks' do

    it 'has many storybooks'

    it 'deletes all associated storybooks when it is deleted'

  end

  context 'when dealing with associated stories' do

    it 'has many stories'

    it 'deletes all associated stories when it is deleted'

  end

end