require 'spec_helper'

describe 'resetting a user password' do

  it 'redirects the user to a page that allows the user to enter their email address' do
    visit signin_url

    click_link 'Forgot your password?'

    expect(current_path).to eq(new_password_reset_path)

    expect(page).to have_field('Email')
  end

  it 'finds the user by email address if the user is active and sends an email with a link' do
    ActionMailer::Base.deliveries.clear

    User.create!(user_attributes)

    visit new_password_reset_url

    fill_in 'Email', with: 'user@example.com'

    click_button 'Send me instructions'

    expect(current_path).to eq(password_resets_path)

    expect(page).to have_text('An email has been sent with password reset instructions.  You may close this window.')

    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end

  it 'does not find the user by email address if the user is inactive' do
    visit new_password_reset_url

    fill_in 'Email', with: 'dave@example.com'

    click_button 'Send me instructions'

    expect(current_path).to eq(password_resets_path)

    expect(page).to have_text('Email address not found.  Please try again.')
  end

  it 'accepts a valid password reset and signs the user in' do
    user = User.create!(user_attributes)

    user.create_reset_digest
    email_string = "user%40example.com"

    visit "http://localhost:3000/password_resets/#{user.reset_token}/edit?email=#{email_string}"

    expect(page).to have_field('Password')
    expect(page).to have_field('Confirm password')

    fill_in 'Password', with: 'secret'
    fill_in 'Confirm password', with: 'secret'
    click_button 'Change my password'

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text('Your password has been reset.')
  end

  it 'rejects a blank password reset' do
    user = User.create!(user_attributes)

    user.create_reset_digest
    email_string = "user%40example.com"

    visit "http://localhost:3000/password_resets/#{user.reset_token}/edit?email=#{email_string}"

    expect(page).to have_field('Password')
    expect(page).to have_field('Confirm password')

    fill_in 'Password', with: ' '
    fill_in 'Confirm password', with: 'secret'
    click_button 'Change my password'

    expect(page).to have_field('Password')
    expect(page).to have_field('Confirm password')
    expect(page).to have_text("Password can't be blank.")
  end

  it 'rejects and invalid password reset' do
    user = User.create!(user_attributes)

    user.create_reset_digest
    email_string = "user%40example.com"

    visit "http://localhost:3000/password_resets/#{user.reset_token}/edit?email=#{email_string}"

    expect(page).to have_field('Password')
    expect(page).to have_field('Confirm password')

    fill_in 'Password', with: 'secret '
    fill_in 'Confirm password', with: 'secret2'
    click_button 'Change my password'

    expect(page).to have_field('Password')
    expect(page).to have_field('Confirm password')
    expect(page).to have_text("We were unable to reset your password.  Please contact customer support.")
  end

end