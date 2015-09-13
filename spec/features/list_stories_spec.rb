require 'rails_helper'

describe 'listing a users stories', type: :feature do

  before do
    create_user
    sign_in(@user)

  end

  context 'there are stories to render' do
    before do
      create_user_stories
      visit stories_url
      user2 = User.create!(user_attributes(email: 'user2@example.com'))
      user2.storybooks.create!(storybook_attributes(title: 'Story Four Title'))
    end

    it 'shows the stories belonging to the correct user and show their relevant data' do
      expect(page).to have_text('Story Title')
      expect(page).to have_text('Story Two Title')
      expect(page).to have_text(@story_1.storybooks.count)
      expect(page).to have_text('ago')
    end

    it 'does not show stories not belonging to the correct user' do
      visit stories_url

      expect(page).to_not have_text('Story Four Title')
    end
  end

  context 'there are no stories to render' do
    it 'should render the nothing_to_render_alert partial if there are no stories' do
      visit stories_url

      expect(page).to have_text('No stories to display.')
    end
  end

end