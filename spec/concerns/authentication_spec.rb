require 'rails_helper'

describe Authentication, type: :concern do

  describe '.authenticate' do
    let(:user) { create(:user) }

    context 'user is valid' do
      it 'returns the user if the email and password match' do
        expect(User.authenticate(user.email, user.password)).to eql(user)
      end
    end

    context 'user is invalid' do
      it 'returns non-true value if the password does not match' do
        expect(User.authenticate(user.email, 'wrong')).to be_falsey
      end

      it 'returns non-true value if the email does not match' do
        expect(User.authenticate('nomatch', user.password)).to be_falsey
      end
    end
  end

end
