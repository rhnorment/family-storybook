require 'rails_helper'

describe 'listing a users stories', type: :feature do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, email: 'user_2@example.com') }

  before { sign_in(user) }

  context 'there are stories to render' do
    before do
      @story_1 = create(:story, user: user)
      @story_2 = create(:story, user: user)
      @story_3 = create(:story, user: user_2)

      visit stories_url
    end

    it 'shows the stories belonging to the correct user and show their relevant data' do
      expect(page).to have_text(@story_1.title)
      expect(page).to have_text(@story_2.title)
      expect(page).to have_text(@story_1.storybooks.count)
      expect(page).to have_text(@story_2.storybooks.count)
      expect(page).to have_text('ago')
    end

    it 'does not show stories not belonging to the correct user' do
      visit stories_url

      expect(page).to_not have_text(@story_3.title)
    end
  end

  context 'there are no stories to render' do
    it 'should render the nothing_to_render_alert partial if there are no stories' do
      visit stories_url

      expect(page).to have_text('No stories to display.')
    end
  end

end