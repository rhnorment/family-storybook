require 'rails_helper'

describe 'delete a storybook', type: :feature do

  let(:user) { create(:user) }

  before do
    sign_in(user)
    @storybook_1 = create(:storybook, user: user)
    @story_1 = create(:story, user: user)
    @storybook_1.stories << @story_1

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
      expect(page).not_to have_text(@storybook_1.title)
    end

    it 'does not delete the associated storybook_stories' do
      expect(user.stories.count).to eql(1)
    end
  end

end