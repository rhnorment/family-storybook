require 'rails_helper'

describe 'delete a story', type: :feature do

  let(:user) { create(:user) }

  before do
    sign_in(user)
    @storybook_1 = create(:storybook, user: user)
    @story_1 = create(:story, user: user)
    @storybook_1.stories << @story_1

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
      expect(page).not_to have_text(@story_1.title)
    end

    it 'does not delete associated storybooks' do
      expect(user.storybooks.count).to eql(1)
    end
  end

end