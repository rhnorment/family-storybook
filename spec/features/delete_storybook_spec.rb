require 'rails_helper'

describe 'delete a storybook', type: :feature do

  before do
    create_user
    sign_in(@user)
    create_user_storybooks
    create_user_stories
    create_storybook_stories
    visit edit_storybook_url(@storybook_1)
  end

  describe 'delete action is visible and actionable to the user' do
    it 'is visible and actionable' do
      expect(page).to have_link('Delete this storybook')
    end
  end

  describe 'user deletes the selected storybook' do
    before { click_link 'Delete this storybook' }

    it 'deletes the selected storybook' do
      expect(page).not_to have_text('Storybook Title')
    end

    it 'does not delete the associated storybook_stories' do
      expect(@user.stories.count).to eql(2)
    end
  end

end