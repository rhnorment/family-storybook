require 'rails_helper'

describe 'page not found exception handling', type: :feature do

  context 'when a page is not found' do
    it 'should present the page not found error page when visiting an unavailable page' do
      visit '/foo'

      expect(page).to have_text('Page not found.')
      expect(page).to have_link('OK')
    end

    it 'should return the user to the home page when the user clicks the ok link' do
      visit root_url

      visit '/foo'

      click_link 'OK'

      expect(current_path).to eq(root_path)
    end
  end

  context 'when a record is not found' do
    it 'should flash an error message and redirect the user back to his profile page' do
      create_user
      sign_in(@user)

      visit storybooks_url
      visit storybook_url(42)

      expect(current_path).to eq(user_path(@user))
      expect(page).to have_text('The item you are looking for is not available.')
    end
  end

end


