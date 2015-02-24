# put this in the new file spec/features/create_user_spec.rb

require 'spec_helper'

describe 'Creating a new user' do

  it 'saves the user and shows the user profile page' do
    ActionMailer::Base.deliveries.clear

    visit root_url

    click_link 'Sign up'

    expect(current_path).to eq(signup_path)

    fill_in "Name",  with: "Example User"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "secret"
    fill_in "Confirm password", with: "secret"

    click_button 'Register'

    expect(current_path).to eq(user_path(User.last))
    expect(page).to have_text('Example User')
    expect(page).to have_text('Thanks for signing up!')
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(PublicActivity::Activity.last.trackable.name).to eq(User.last.name)
  end

  it 'does not save the user if invalid' do
    visit signup_url

    expect {
      click_button 'Register'
    }.not_to change(User, :count)

    expect(page).to have_text("can't be blank")
  end

end
