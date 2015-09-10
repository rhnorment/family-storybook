require 'rails_helper'

describe 'showing a storybook', type: :feature do

  before do
    create_user
    sign_in(@user)
    create_user_stories
  end

  it 'shows a story details' do
    visit story_url(@story_1)

    expect(page).to have_text(@story_1.title)
    expect(page).to have_text(@story_1.content)
    expect(page).to have_text(@story_1.user.name)
    expect(page).to have_link('Edit this story')
    expect(page).to have_link('Return to my stories')
  end

end