require 'rails_helper'

describe 'Signing out', type: :feature do

  it 'removes the user id from the session' do
    user = User.create!(user_attributes)

    sign_in(user)

    click_link 'Sign out'

    expect(current_path).to eq(signin_path)
    expect(page).to have_text('signed out')
    expect(page).not_to have_link('Sign out')
  end

end