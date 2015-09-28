require 'rails_helper'

describe 'showing a storybook', type: :feature do

  let(:user)        { create(:user) }
  let(:storybook)   { create(:storybook, user: user) }
  let(:story_1)     { create(:story, user: user) }
  let(:story_2)     { create(:story, user: user) }

  before do
    sign_in(user)
    storybook.stories << [story_1, story_2]

    visit storybook_url(storybook)
  end

  it 'shows a storybooks details and included stories' do
    expect(page).to have_text(storybook.title)
    expect(page).to have_text(storybook.description)
    expect(page).to have_text(storybook.user.name)
    expect(page).to have_text(story_1.title)
    expect(page).to have_text(story_2.title)
    expect(page).to have_selector("img[src$='#{storybook.cover_url}']")
    expect(page).to have_link('Edit this storybook')
    expect(page).to have_link('Return to my storybooks')
  end

end