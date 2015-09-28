require 'rails_helper'

describe 'Signing in', type: :feature do

  describe 'the signin page is accessible and prompts the user to enter his/her user_id and password' do
    it 'prompts for an email and password' do
      visit root_url

      click_link 'Sign in'

      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
    end
  end

  describe 'user attempts to sign into the system' do
    context 'user enters a valid email/password combination AND is active' do
      before do
        create(:user)
        visit signin_url
      end

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

    context 'user enters a valid email/password combination BUT is not active' do
      before do
        create(:user, :inactive_user)
        visit signin_url
      end

      it 'does not sign the user in' do
        fill_in 'Email', with: 'inactive_user@example.com'
        fill_in 'Password', with: 'secret'

        click_button 'Sign in'

        expect(page).to have_text('Your account is currently inactive.')
        expect(page).not_to have_link('Inactive User')
        expect(page).not_to have_link('Sign out')
      end
    end

    context 'user enters an invalid email / password combination' do
      before do
        create(:user)
        visit signin_url
      end

      it 'does not sign the user in' do
        fill_in 'Email', with: 'wrong_user@example.com'
        fill_in 'Password', with: 'no match'

        click_button 'Sign in'

        expect(page).to have_text('Invalid email/password combination.')
        expect(page).not_to have_link('Invalid User')
        expect(page).not_to have_link('Sign out')
      end
    end
  end

end