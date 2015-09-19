require 'rails_helper'

describe Account, type: :concern do

  describe '#activate' do

    context 'new user is not valid' do
      before { @bad_user = User.new(name: nil, email: nil, password: nil, password_confirmation: nil) }

      it 'returns FALSE if the new user is not valid' do
        expect(@bad_user.activate).to be_falsey
      end

      it 'does not save the record to the database' do
        expect { @bad_user.activate }.to_not change(User, :count)
      end

      it 'does not send an activation email' do
        expect { @bad_user.activate }.to_not change(ActionMailer::Base.deliveries, :count)
      end

      it 'does not create an activity record' do
        expect { @bad_user.activate }.to_not change(Activity, :count)
      end
    end

    context 'new user is valid' do
      before { @user = User.new(user_attributes) }

      it 'returns TRUE if the new user is not valid' do
        expect(@user.activate).to be_truthy
      end

      it 'saves the record to the database' do
        expect { @user.activate }.to change(User, :count).by(+1)
      end

      it 'sends an activation email' do
        expect { @user.activate }.to change(ActionMailer::Base.deliveries, :count).by(+1)
      end

      it 'creates an activity record' do
        expect { @user.activate }.to change(Activity, :count).by(+1)
      end
    end
  end

  describe '#is_active' do
    context 'for an active user' do
      before { create_user }

      it 'is active' do
        expect(@user.is_active?).to be_truthy
      end
    end

    context 'for an inactive user'
  end

  describe '#is_inactive' do
    context 'for an active user' do
      before { create_user }

      it 'is not inactive' do
        expect(@user.is_inactive?).to be_falsey
      end
    end

    context 'for an inactive user'
  end

end