require 'rails_helper'

describe 'edit a story', type: :feature do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'updates the story and shows the updated attributes' do
    story = @user.stories.create!(story_attributes)

    visit story_url(story)

    click_link 'Edit this story'

    expect(current_path).to eq(edit_story_path(story))
    expect(page).to have_field('Title')
    expect(page).to have_field('Content')
    expect(page).to have_link('Delete this story')


    fill_in 'Title', with: 'Updated Title'
    fill_in 'Content', with: 'Updated content'
    click_button 'Update my story'

    expect(current_path).to eq(story_path(story))
    expect(page).to have_text('Updated Title')
    expect(page).to have_text('Updated content')
  end

  it 'does not update a story with a blank title' do
    story = @user.stories.create!(story_attributes)

    visit story_url(story)

    click_link 'Edit this story'

    expect(current_path).to eq(edit_story_path(story))
    expect(page).to have_field('Title')
    expect(page).to have_field('Content')
    expect(page).to have_link('Delete this story')


    fill_in 'Title', with: ' '
    fill_in 'Content', with: 'Updated content'
    click_button 'Update my story'

    expect(page).to have_text('There was a problem updating your story.  Please try again.')
  end

end