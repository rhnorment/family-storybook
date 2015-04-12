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
#

require 'spec_helper'

describe User do

  it 'requires a name' do
    user = User.new(name: '')
    user.valid?
    expect(user.errors[:name].any?).to be_true
  end

  it 'requires an email' do
    user = User.new(email: '')
    user.valid?
    expect(user.errors[:email].any?).to be_true
  end

  it 'accepts a properly formatted email' do
    emails = %w[user@example.com first.last@example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to be_false
    end
  end

  it 'rejects an improperly formatted email' do
    emails = %w[@ user@ @example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to be_true
    end
  end

  it 'require a unique, case sensitive email address' do
    user1 = User.create!(user_attributes)
    user2 = User.new(email: user1.email.upcase)
    user2.valid?
    expect(user2.errors[:email].first).to eq('has already been taken')
  end

  it 'is valid with example attributes' do
    user = User.new(user_attributes)
    expect(user.valid?).to be_true
  end

  it 'requires a password' do
    user = User.new(password: '')
    user.valid?
    expect(user.errors[:password].any?).to be_true
  end

  it 'requires a password confirmation when a password is present' do
    user = User.new(password: 'secret', password_confirmation: '')
    user.valid?
    expect(user.errors[:password_confirmation].any?).to be_true
  end

  it 'it requires the password to match the password confirmation' do
    user = User.new(password: 'secret', password_confirmation: 'nomatch')
    user.valid?
    expect(user.errors[:password_confirmation].first).to eq("doesn't match Password")
  end

  it 'requires a password and matching password confirmation when creating' do
    user = User.create!(user_attributes(password: 'secret', password_confirmation: 'secret'))
    expect(user.valid?).to be_true
  end

  it 'does not require a password when updating' do
    user = User.create!(user_attributes)
    user.password = ''
    expect(user.valid?).to be_true
  end

  it 'automatically encrypts the password into the password_digest attribute' do
    user = User.new(password: 'secret')
    expect(user.password_digest.present?).to be_true
  end

  it 'has many storybooks' do
    user = User.create!(user_attributes)

    storybook1 = user.storybooks.new(storybook_attributes)
    storybook2 = user.storybooks.new(storybook_attributes)

    expect(user.storybooks).to include(storybook1)
    expect(user.storybooks).to include(storybook2)
  end

  it 'deletes associated storybooks' do
    user = User.create!(user_attributes)

    user.storybooks.create!(storybook_attributes)

    expect { user.destroy }.to change(Storybook, :count).by(-1)
  end

  it 'has many stories' do
    user = User.create!(user_attributes)

    story1 = user.stories.new(story_attributes)
    story2 = user.stories.new(story_attributes)

    expect(user.stories).to include(story1)
    expect(user.stories).to include(story2)
  end

  it 'deletes associated stories' do
    user = User.create!(user_attributes)

    user.stories.create!(story_attributes)

    expect { user.destroy }.to change(Story, :count).by(-1)
  end

  describe 'authenticate' do
    before do
      @user = User.create!(user_attributes)
    end

    it "returns non-true value if the email does not match" do
      expect(User.authenticate("nomatch", @user.password)).not_to eq(true)
    end

    it "returns non-true value if the password does not match" do
      expect(User.authenticate(@user.email, "nomatch")).not_to eq(true)
    end

    it "returns the user if the email and password match" do
      expect(User.authenticate(@user.email, @user.password)).to eq(@user)
    end
  end

end
