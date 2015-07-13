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

    it 'has a valid factory'

    it 'is invalid without a name'

    it 'is invalid without an email'

    it 'is invalid without a valid email address'

    it 'is invalid without a unique, case sensitive email address'

    it 'is invalid without a password'

    it 'requires a password confirmation when the password is present'

    it 'is invalid if the password and password confirmation do not match'

    it 'does not require a password when updating'

    it 'automatically encrypts the password into the password_digest attribute'

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