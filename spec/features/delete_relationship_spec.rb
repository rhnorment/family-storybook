require 'rails_helper'

describe 'delete a relationship', type: :feature do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, name: 'User Two', email: 'user_2@example.com') }
  let(:user_3)  { create(:user, name: 'User Three', email: 'user_3@example.com') }
  let(:user_4)  { create(:user, name: 'User Four', email: 'user_4@example.com') }

  before do
    sign_in(user)
  end

  describe 'delete action is visible and actionable to the user' do
    before do
      Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false)
      user.invite(user_3)
      user_4.invite(user)
    end

    context 'when removing an approved relationship' do
      it 'is visible and actionable to the user' do
        visit relationships_url

        expect(page).to have_link('Remove')
      end
    end

    context 'when cancelling an outgoing relationship request that has not been approved' do
      it 'is visible and actionable to the user' do
        visit pending_relationships_url

        within(:css, '#outgoing-requests') do
          expect(page).to have_link('Cancel')
        end
      end
    end

    context 'when rejecting an incoming relationship request' do
      it 'is visible and actionable to the user' do
        visit pending_relationships_url

        within(:css, '#incoming-requests') do
          expect(page).to have_link('Reject')
        end
      end
    end
  end

  describe 'user deletes the relationship' do
    before do
      Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false)
      user.invite(user_3)
      user_4.invite(user)
    end

    context 'deleting an active relationship' do
      before do
        visit relationships_url

        within(:css, '#relatives') do
          first('.list-group-item').click_link('Remove')
        end
      end

      it 'removes the existing relationship' do
        expect(page).to_not have_text(user_2.name)
      end
    end

    context 'cancelling an outgoing relationship request' do
      it 'cancels tje outgoing request' do
        visit pending_relationships_url

        within(:css, '#outgoing-requests') do
          first('.list-group-item').click_link('Cancel')
        end

        expect(page).to_not have_text(user_3.name)
      end

    end

    context 'rejecting an incoming relationship request' do
      it 'cancels tje outgoing request' do
        visit pending_relationships_url

        within(:css, '#incoming-requests') do
          first('.list-group-item').click_link('Reject')
        end

        expect(page).to_not have_text(user_4.name)
      end
    end
  end

end