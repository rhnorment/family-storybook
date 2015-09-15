require 'rails_helper'

describe 'create story', type: :feature do

  before do
    create_user
    sign_in(@user)
  end

  describe 'CREATE action is accessible and prompts the user for :create attributes' do
    before do
      visit stories_url
      click_link 'Write a new story'
    end

    it 'is accessible to the user' do
      expect(current_path).to eql(new_story_path)
    end

    it 'prompts the user for the :create attributes' do
      expect(page).to have_field('Title')
      expect(page).to have_field('Content')
      expect(page).to have_button('Save my story')
    end

  end

  describe 'user attempts to create a new storybook' do
    before { visit new_story_url }

    context 'user enters valid :create attributes' do
      it 'creates and redirects to the new story' do
        fill_in 'Title', with: 'New Story Title'
        fill_in 'Content', with: 'This is my story content'

        click_button 'Save my story'

        expect(current_path).to eq(story_path(Story.last))

        expect(page).to have_text('New Story Title')
        expect(page).to have_text('Your story was saved.')
      end
    end

    context 'user enters invalid :create attributes' do
      it 'does not create the new story and renders the :create form' do
        fill_in 'Title', with: ''
        fill_in 'Content', with: 'This is my story content'

        click_button 'Save my story'

        expect(page).to have_text('There was a problem saving your story.  Please try again')
      end
    end
  end

end