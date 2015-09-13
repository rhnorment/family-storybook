require 'rails_helper'

describe 'edit a story', type: :feature do

  before do
    create_user
    sign_in(@user)
    create_user_stories
  end

  describe 'the edit view is accessible and prompts the user for the correct attributes' do
    it 'updates the story and shows the updated attributes' do
      visit story_url(@story_1)

      click_link 'Edit this story'

      expect(current_path).to eq(edit_story_path(@story_1))
      expect(page).to have_field('Title')
      expect(page).to have_field('Content')
      expect(page).to have_link('Delete this story')
    end
  end

  describe 'user updates the story' do
    before { visit edit_story_url(@story_1) }

    context 'user enters correct update attributes' do
      it 'updates the story with the correct update attributes' do
        fill_in 'Title', with: 'Updated Title'
        fill_in 'Content', with: 'Updated content'
        click_button 'Update my story'

        expect(current_path).to eq(story_path(@story_1))
        expect(page).to have_text('Updated Title')
        expect(page).to have_text('Updated content')
      end
    end

    context 'user enters incorrect update attributes' do
      it 'does not update a story with a blank title' do
        expect(page).to have_field('Title')
        expect(page).to have_field('Content')
        expect(page).to have_link('Delete this story')


        fill_in 'Title', with: ' '
        fill_in 'Content', with: 'Updated content'
        click_button 'Update my story'

        expect(page).to have_text('There was a problem updating your story.  Please try again.')
      end
    end
  end

end