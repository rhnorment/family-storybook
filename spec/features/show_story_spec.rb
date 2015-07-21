require 'rails_helper'

describe 'showing a storybook', type: :feature do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'shows a story details' do
    story = @user.stories.create!(story_attributes)

    visit story_url(story)

    expect(page).to have_text(story.title)
    expect(page).to have_text(story.content)
    expect(page).to have_text(story.user.name)
    expect(page).to have_link('Edit this story')
    expect(page).to have_link('Return to my stories')
  end

end