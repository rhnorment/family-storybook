require 'spec_helper'

describe 'delete a user' do

  it 'automatically signs out that user' do
    user = User.create!(user_attributes)

    sign_in(user)

    visit edit_user_path(user)

    click_link 'Delete my account'

    expect(page).to have_link('Sign in')
    expect(page).not_to have_link('Sign out')
  end

end