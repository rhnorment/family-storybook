require 'rails_helper'

describe 'delete a relationship', type: :feature do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'User2 Example'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'User3 Example'))
    sign_in(@user1)
  end

  context 'when deleting an active relationship' do
    before do
      @user1.invite(@user2)
      @user2.approve(@user1)
    end

    it 'should display a list of current relatives with links to remove each relationship' do
      visit relationships_url

      expect(page).to have_text(@user2.name)
      expect(page).to have_text('Became')
      expect(page).to have_link('Remove')
    end

    it 'should allow the user to remove the relationship' do
      visit relationships_url

      click_link('Remove')

      expect(current_path).to eq(relationships_path)
      expect(page).to have_text('Your family member was removed.')
      expect(page).to_not have_text(@user2.name)
    end
  end

  context 'when cancelling a relationship request that has not been approved' do
    before do
      @user1.invite(@user2)
    end

    it 'should allow the user to cancel the invitation request' do
      visit pending_relationships_url

      within('#outgoing-invitations') do
        click_link('Cancel')
      end

      expect(current_path).to eq(relationships_path)
      expect(page).to have_text('Your family member was removed.')
      expect(page).to_not have_text(@user2.name)
    end
  end

  context 'when denying an inbound relationship request' do
    before do
      @user2.invite(@user1)
    end

    it 'should allow a user to reject an incoming relationship request' do
      visit pending_relationships_url

      within('#incoming-invitations') do
        click_link('Reject')
      end

      expect(current_path).to eq(relationships_path)
      expect(page).to have_text('Your family member was removed.')
      expect(page).to_not have_text(@user2.name)
    end
  end

  context 'when cancelling an invitation opportunity if the recipient email is found' do
    it 'should present the user with the option to send an invitation or cancel altogether' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button('Invite by email')

      within('#recipients') do
        expect(page).to have_link('Invite')
        expect(page).to have_link('Cancel')
      end
    end

    it 'should allow the user to cancel the invitation request option' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button('Invite by email')

      within('#recipients') do
        click_link('Cancel')
      end

      expect(current_path).to eq(new_relationship_path)
    end
  end

end