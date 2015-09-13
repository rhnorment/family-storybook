require 'rails_helper'

describe 'delete a relationship', type: :feature do

  before do
    create_user
    create_other_users
    sign_in(@user)
    create_user_relationships
  end

  describe 'delete action is visible and actionable to the user' do
    context 'when removing an approved relationship' do
      it 'is visible and actionable to the user' do
        visit relationships_url

        expect(page).to have_link('Remove')
      end
    end

    context 'when cancelling an outgoing relationship request that has not been approved' do
      it 'is visible and actionable to the user' do
        @user.invite(@user_4)

        visit pending_relationships_url

        within(:css, '#outgoing-requests') do
          expect(page).to have_link('Cancel')
        end
      end
    end

    context 'when rejecting an incoming relationship request' do
      it 'is visible and actionable to the user' do
        @user_5.invite(@user)

        visit pending_relationships_url

        within(:css, '#incoming-requests') do
          expect(page).to have_link('Reject')
        end
      end
    end
  end

  describe 'user deletes the relationship' do
    context 'deleting an active relationship' do    # relatives listed LIFO
      before do
        visit relationships_url

        within(:css, '#relatives') do
          first('.list-group-item').click_link('Remove')
        end
      end

      it 'removes the existing relationship' do
        expect(page).to_not have_text('User Three')
      end

      it 'keeps the remaining relationships' do
        expect(page).to have_text('User Two')
      end
    end

    context 'cancelling an outgoing relationship request' do
      it 'cancels tje outgoing request' do
        @user.invite(@user_4)

        visit pending_relationships_url

        within(:css, '#outgoing-requests') do
          first('.list-group-item').click_link('Cancel')
        end

        expect(page).to_not have_text('User Four')
      end

    end

    context 'rejecting an incoming relationship request' do
      it 'cancels tje outgoing request' do
        @user_5.invite(@user)

        visit pending_relationships_url

        within(:css, '#incoming-requests') do
          first('.list-group-item').click_link('Reject')
        end

        expect(page).to_not have_text('User Five')
      end
    end
  end

end