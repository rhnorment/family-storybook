require 'rails_helper'

describe 'Creating a new user', type: :feature do

  describe 'the user registration page is accessible and prompts for the attributes' do
    it 'is accessible and prompts the user for account creation attributes' do
      visit root_url

      click_link 'Sign up'

      expect(current_path).to eql(signup_path)

      expect(page).to have_field('Name')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Confirm password')
      expect(page).to have_button('Register')
      expect(page).to have_link('Cancel')
      expect(page).to have_link('Sign in here')  # if user already has account.
    end
  end

  describe 'the user creates an account' do
    before { visit signup_url }

    context 'user enters valid parameters parameters' do
      it 'creates the account and redirects the user dashboard' do
        fill_in 'Name',  with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'secret'
        fill_in 'Confirm password', with: 'secret'

        click_button 'Register'

        expect(current_path).to eq(user_path(User.last))
        expect(page).to have_text('Example User')
        expect(page).to have_text('Thanks for signing up!')
      end
    end

    context 'user enters invalid parameters' do
      it 'does not create the account and renders the form again' do
        click_button 'Register'

        expect(page).to have_text("can't be blank")
      end
    end
  end

end
