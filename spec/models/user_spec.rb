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
    it 'is valid with example attributes' do
      expect(User.new(user_attributes)).to be_valid
    end

    it 'is invalid without a name' do
      expect(User.new(name: nil)).to_not be_valid
    end

    it 'is invalid without an email' do
      expect(User.new(email: nil)).to_not be_valid
    end

    it 'is invalid without a valid email address' do
      expect(User.new(email: 'example.com')).to_not be_valid
    end

    it 'is invalid without a unique, case sensitive email address' do
      user1 = User.create!(user_attributes)
      user2 = User.new(email: user1.email.downcase)
      expect(user2).to_not be_valid
      expect(user2.errors[:email].first).to eql('has already been taken')
    end

    it 'is invalid without a password' do
      expect(User.new(password: nil)).to_not be_valid
    end

    it 'requires a password confirmation when the password is present' do
      expect(User.new(password: 'secret', password_confirmation: '')).to_not be_valid
    end

    it 'is invalid if the password and password confirmation do not match' do
      expect(User.new(password: 'secret', password_confirmation: 'nomatch')).to_not be_valid
    end

    it 'does not require a password when updating' do
      user = User.new(user_attributes)
      user.password = ''
      expect(user).to be_valid
    end

    it 'automatically encrypts the password into the password_digest attribute' do
      user = User.new(user_attributes)
      expect(user.password_digest.present?).to eql(true)
    end
  end

  context 'when authenticating a user' do
    before do
      @user = User.create!(name: 'Example User', email: 'user@example.com', password: 'secret', password_confirmation: 'secret')
    end

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

  context 'when dealing with associated storybooks' do
    before do
      @user = User.create!(user_attributes)
      @storybook1 = @user.storybooks.create!(storybook_attributes)
      @storybook2 = @user.storybooks.create!(storybook_attributes)
    end

    it 'has many storybooks' do
      expect(@user.storybooks).to include(@storybook1, @storybook2)
    end

    it 'deletes all associated storybooks when it is deleted' do
      expect { @user.destroy }.to change(Storybook, :count).by(-2)
    end
  end

  context 'when dealing with associated stories' do
    before do
      @user = User.create!(user_attributes)
      @story1 = @user.stories.create!(story_attributes)
      @story2 = @user.stories.create!(story_attributes)
    end

    it 'has many stories' do
      expect(@user.stories).to include(@story1, @story2)
    end

    it 'deletes all associated stories when it is deleted' do
      expect { @user.destroy }.to change(Story, :count).by(-2)
    end
  end

  context 'when associating with tracking an activity' do
    it 'creates an associated activity when created'

    it 'deletes the associated activity when deleted'
  end

end