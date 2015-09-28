require 'rails_helper'

describe 'resetting a user password', type: :feature do

  it 'redirects the user to a page that allows the user to enter their email address' do
    visit signin_url

    click_link 'Forgot your password?'

    expect(page).to have_field('Email')
  end

  describe 'user is entering his/her email address for the password reset instructions' do
    before do
      create(:user)
      visit new_password_reset_url
    end

    context 'the user is found' do
      it 'finds the user by email address if the user is active and sends an email with a link' do
        ActionMailer::Base.deliveries.clear

        fill_in 'Email', with: 'user@example.com'

        click_button 'Send me instructions'

        expect(page).to have_text('An email has been sent with password reset instructions.  You may close this window.')

        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end

    context 'the user is not found' do
      it 'does not find the user by email address if the user is inactive' do
        fill_in 'Email', with: 'dave@example.com'

        click_button 'Send me instructions'

        expect(page).to have_text('Email address not found.  Please try again.')
      end
    end
  end

  describe 'user is resetting his/her password' do
    let(:user)  { create(:user) }

    before do
      user.create_reset_digest
      @email_string = "user%40example.com"
      visit "http://localhost:3000/password_resets/#{user.reset_token}/edit?email=#{@email_string}"
    end

    it 'displays the user prompts' do
      expect(page).to have_field('Password')
      expect(page).to have_field('Confirm password')
    end

    context 'user correctly enters and confirms his/her new password' do
      it 'accepts a valid password reset and signs the user in' do
        fill_in 'Password', with: 'secret'
        fill_in 'Confirm password', with: 'secret'
        click_button 'Change my password'

        expect(page).to have_text('Your password has been reset.')
      end
    end

    context 'user incorrectly enters his/her new password and confirmation' do
      it 'rejects a blank password reset' do
        fill_in 'Password', with: ' '
        fill_in 'Confirm password', with: ''
        click_button 'Change my password'

        expect(page).to have_field('Password')
        expect(page).to have_field('Confirm password')
        expect(page).to have_text('Password cannot be blank.')
      end

      it 'rejects and invalid password reset' do
        fill_in 'Password', with: 'secret'
        fill_in 'Confirm password', with: 'secret2'
        click_button 'Change my password'

        expect(page).to have_field('Password')
        expect(page).to have_field('Confirm password')
        expect(page).to have_text('We were unable to reset your password.  Please contact customer support.')
      end
    end
  end

end