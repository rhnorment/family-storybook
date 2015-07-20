require 'rails_helper'

describe 'create story', type: :feature do

  before do
    user = User.create!(user_attributes)
    sign_in(user)
  end

  it 'saves the story and shows its details' do
    visit stories_url

    click_link 'Write a new story'

    expect(current_path).to eq(new_story_path)

    fill_in 'Title', with: 'New Story Title'
    fill_in 'Content', with: 'This is my story content'

    click_button 'Save my story'

    expect(current_path).to eq(story_path(Story.last))

    expect(page).to have_text('New Story Title')
    expect(page).to have_text('Your story was saved.')
    expect(PublicActivity::Activity.last.trackable.title).to eq(Story.last.title)
  end

  it 'does not save the story if it is invalid' do
    visit new_story_url

    expect { click_button 'Save my story' }.to_not change(Story, :count)
    expect(page).to have_text('There was a problem saving your story.  Please try again')
  end

end