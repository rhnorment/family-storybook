require 'rails_helper'

describe Account, type: :concern do

  describe '#activate' do
    context 'activation is not valid' do
      let(:bad_user) { build(:user, :bad_user) }

      it 'returns FALSE if the new user is not valid' do
        expect(bad_user.activate).to be_falsey
      end

      it 'does not save the record to the database' do
        expect { bad_user.activate }.to_not change(User, :count)
      end

      it 'does not send an activation email' do
        expect { bad_user.activate }.to_not change(ActionMailer::Base.deliveries, :count)
      end

      it 'does not create an activity record' do
        expect { bad_user.activate }.to_not change(Activity, :count)
      end
    end

    context 'activation is valid' do
      let(:user) { build(:user) }

      it 'returns TRUE if the new user is not valid' do
        expect(user.activate).to be_truthy
      end

      it 'saves the record to the database' do
        expect { user.activate }.to change(User, :count).by(+1)
      end

      it 'sends an activation email' do
        expect { user.activate }.to change(ActionMailer::Base.deliveries, :count).by(+1)
      end

      it 'creates an activity record' do
        expect { user.activate }.to change(Activity, :count).by(+1)
      end
    end
  end

  describe '#deactivate' do
    context 'deactivate is not valid' do

    end

    context 'deactivation is valid' do
      let(:user) { create(:user) }

      it 'it makes the active field false' do
        expect { user.deactivate }.to change(user, :active).from(true).to(false)
      end

      it 'sends a deactivation email' do
        expect { user.deactivate }.to change(ActionMailer::Base.deliveries, :count).by(+1)
      end
    end
  end

  describe '#is_active' do
    context 'for an active user' do
      let(:user) { create(:user) }

      it 'is active' do
        expect(user.is_active?).to be_truthy
      end
    end

    context 'for an inactive user' do
      let(:inactive_user) { create(:user, :inactive_user) }

      it 'is not active' do
         expect(inactive_user.is_active?).to be_falsey
      end
    end
  end

  describe '#is_inactive' do
    context 'for an active user' do
      let(:user) { create(:user) }

      it 'is not inactive' do
        expect(user.is_inactive?).to be_falsey
      end
    end

    context 'for an inactive user' do
      let(:inactive_user) { create(:user, :inactive_user) }

      it 'is inactive' do
        expect(inactive_user.is_inactive?).to be_truthy
      end
    end
  end

end