require 'rails_helper'

describe Authentication, type: :concern do

  describe '.authenticate' do
    let(:user) { create(:user) }

    context 'user is valid and active' do
      it 'authenticates the user' do
        expect(User.authenticate('user@example.com', 'secret')).to eql(@user)
      end
    end

    context 'user is invalid' do
      it 'does not authenticate the user' do
        expect(User.authenticate('not_found@example.com', 'secret')).to eql(nil)
      end
    end
  end

end
