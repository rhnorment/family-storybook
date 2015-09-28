require 'rails_helper'

describe 'showing a storybook', type: :feature do

  let(:user)  { create(:user) }
  let(:story) { create(:story, user: user) }

  before do
    sign_in(user)
    visit story_url(story)
  end

  it 'shows a story details' do
    expect(page).to have_text(story.title)
    expect(page).to have_text(story.content)
    expect(page).to have_text(story.user.name)
    expect(page).to have_link('Edit this story')
    expect(page).to have_link('Return to my stories')
  end

end