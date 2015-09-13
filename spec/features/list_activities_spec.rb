require 'rails_helper'

describe 'listing a users activities' do

  before do
    create_user
    sign_in(@user)
  end

  context 'there are activities to render' do
    before do
      create_user_storybooks
      create_user_stories
      user2 = User.create!(user_attributes(email: 'user2@example.com'))
      user2.storybooks.create!(storybook_attributes(title: 'Wrong Storybook Title'))
      user2.stories.create!(story_attributes(title: 'Wrong Story Title'))
      visit activities_url
    end

    it 'shows the user activities belonging to the correct user and relevant information' do
      expect(page).to have_text('Storybook Title')
      expect(page).to have_text('Storybook Two Title')
      expect(page).to have_text('Story Title')
      expect(page).to have_text('Story Two Title')
      expect(page).to have_text('ago')
    end

    it 'does not show activities not belonging to the incorrect user' do
      expect(page).to_not have_text('Wrong Storybook Title')
      expect(page).to_not have_text('Wrong Story Title')
    end
  end

  context 'there are no activites to render' do
    it 'should render the nothing_to_render_alert partial if there are no activities' do
      visit activities_url

      expect(page).to have_text('Example User')
    end
  end

end