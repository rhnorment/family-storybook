require 'rails_helper'

describe Authentication, type: :concern do

  describe '.authenticate' do
    context 'user is valid and active' do
      before { create_user }

      it 'authenticates the user' do
        expect(User.authenticate('user@example.com', 'secret')).to eql(@user)
      end
    end

    context 'user is valid and inactive' do
      before { create_inactive_user }

      it 'does not authenticate the user' do
        expect(User.authenticate('user@example.com', 'secret')).to eql(false)
      end
    end

    context 'user is invalid'
  end

end

# TODO:  add error messages for inactive user