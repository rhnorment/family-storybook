require 'spec_helper'

describe 'showing a storybook' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'shows a storybooks details' do
    storybook = @user.storybooks.create!(storybook_attributes)

    visit storybook_url(storybook)

    expect(page).to have_text(storybook.title)
    expect(page).to have_text(storybook.description)
    expect(page).to have_text(storybook.user.name)
    expect(page).to have_selector("img[src$='#{storybook.cover_url}']")
    expect(page).to have_link('Edit this storybook')
    expect(page).to have_link('Return to my storybooks')
  end

end