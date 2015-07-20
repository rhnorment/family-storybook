require 'spec_helper'

describe 'showing a storybook' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'shows a storybooks details and included stories' do
    storybook = @user.storybooks.create!(storybook_attributes)
    story1 = @user.stories.create!(story_attributes)
    story2 = @user.stories.create!(story_attributes)
    storybook.stories << [story1, story2]

    visit storybook_url(storybook)

    expect(page).to have_text(storybook.title)
    expect(page).to have_text(storybook.description)
    expect(page).to have_text(storybook.user.name)
    expect(page).to have_text(story1.title)
    expect(page).to have_text(story2.title)
    expect(page).to have_selector("img[src$='#{storybook.cover_url}']")
    expect(page).to have_link('Edit this storybook')
    expect(page).to have_link('Return to my storybooks')
  end

end