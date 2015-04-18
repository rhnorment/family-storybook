require 'spec_helper'

describe 'delete a relationship' do

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

    it 'should display a list of current relatives with links to renove each relationship' do
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

  context 'when cancelling a relationship request that has not been approved'

  context 'when denying an inbound relationship request'

end