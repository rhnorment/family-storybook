require 'rails_helper'

describe 'delete a user', type: :feature do
  before do
    create_user
    sign_in(@user)
    visit edit_user_path(@user)
  end

  describe 'delete action is visible and accessible to the user' do
    it 'presents the delete action to the user' do
      expect(page).to have_link('Delete my account')
    end
  end

  describe 'user deletes his/her account' do
    it 'automatically signs out that user' do
      click_link 'Delete my account'

      expect(page).to have_link('Sign in')
      expect(page).not_to have_link('Sign out')
    end

    it 'sends an email to the user confirming the account removal'

  end

end