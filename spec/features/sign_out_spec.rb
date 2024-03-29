require 'rails_helper'

describe 'Signing out', type: :feature do

  let(:user) { create(:user) }

  it 'removes the user id from the session' do
    sign_in(user)

    click_link 'Sign out'

    expect(page).to have_text('You are now signed out')
    expect(page).not_to have_link('Sign out')
  end

end