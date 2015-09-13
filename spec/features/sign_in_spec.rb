require 'rails_helper'

describe 'Signing in', type: :feature do
  before { create_user }

  describe 'the signin page is accessible and prompts the user to enter his/her user_id and password' do
    it 'prompts for an email and password' do
      visit root_url

      click_link 'Sign in'

      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
    end
  end

  describe 'user attempts to sign into the system' do
    before { visit signin_url }

    context 'user enters a valid email / password combination' do
      it 'signs the user in' do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'secret'

        click_button 'Sign in'

        expect(page).to have_field('query')
        expect(page).to have_link('Sign out')
        expect(page).not_to have_link('Sign in')
        expect(page).not_to have_link('Sign up')
      end
    end

    context 'user enters an invalid email / password combination' do
      it 'does not sign the user in' do
        fill_in 'Email', with: 'wrong_user@example.com'
        fill_in 'Password', with: 'no match'

        click_button 'Sign in'

        expect(page).to have_text('Invalid')
        expect(page).not_to have_link(@user.name)
        expect(page).not_to have_link('Sign out')
      end
    end
  end

end