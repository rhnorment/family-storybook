require 'rails_helper'

describe 'showing a storybook', type: :feature do

  before do
    create_user
    sign_in(@user)
    create_user_storybooks
    create_user_stories
  end

  it 'shows a storybooks details and included stories' do
    @storybook_1.stories << [@story_1, @story_2]

    visit storybook_url(@storybook_1)

    expect(page).to have_text(@storybook_1.title)
    expect(page).to have_text(@storybook_1.description)
    expect(page).to have_text(@storybook_1.user.name)
    expect(page).to have_text(@story_1.title)
    expect(page).to have_text(@story_2.title)
    expect(page).to have_selector("img[src$='#{@storybook_1.cover_url}']")
    expect(page).to have_link('Edit this storybook')
    expect(page).to have_link('Return to my storybooks')
  end

end