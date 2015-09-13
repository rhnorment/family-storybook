require 'rails_helper'

describe 'delete a story', type: :feature do

  before do
    create_user
    sign_in(@user)
    create_user_storybooks
    create_user_stories
    create_storybook_stories
    visit edit_story_url(@story_1)
  end

  describe 'delete action is visible and actionable to the user' do
    it 'is visible and actionable' do
      expect(page).to have_link('Delete this story')
    end
  end

  describe 'user deletes the selected story' do
    before { click_link 'Delete this story' }

    it 'deletes the selected story' do
      expect(page).not_to have_text('Story Title')
    end

    it 'does not delete associated storybooks' do
      expect(@user.storybooks.count).to eql(2)
    end
  end

end