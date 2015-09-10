require 'rails_helper'

describe 'Signing in', type: :feature do
  before { create_user }

  it 'prompts for an email and password' do
    visit root_url

    click_link 'Sign in'

    expect(current_path).to eq(signin_path)

    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  scenario 'signing in the user if the email/password combination is valid' do
    visit root_url

    click_link 'Sign in'

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'secret'

    click_button 'Sign in'

    expect(page).to have_field('query')
    expect(page).to have_link('Sign out')
    expect(page).not_to have_link('Sign in')
    expect(page).not_to have_link('Sign up')
  end

  scenario 'does not sign in the user if the email/password combination is invalid' do
    visit root_url

    click_link 'Sign in'

    fill_in 'Email', with: 'wrong_user@example.com'
    fill_in 'Password', with: 'no match'

    click_button 'Sign in'

    expect(page).to have_text('Invalid')
    expect(page).not_to have_link(@user.name)
    expect(page).not_to have_link('Sign out')
  end

end