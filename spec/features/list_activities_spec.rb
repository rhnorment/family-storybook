require 'rails_helper'

describe 'listing a users activities' do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, email: 'user_2@example.com') }

  before do
    user.activate
    sign_in(user)
  end

  context 'there are activities to render' do
    before do
      @storybook_1 = create(:storybook, user: user)
      @storybook_2 = create(:storybook, user: user)
      @storybook_3 = create(:storybook, user: user_2)
      @story_1 = create(:story, user: user)
      @story_2 = create(:story, user: user)
      @story_3 = create(:story, user: user_2)

      visit activities_url
    end

    it 'shows the user activities belonging to the correct user and relevant information' do
      expect(page).to have_text(@storybook_1.title)
      expect(page).to have_text(@storybook_2.title)
      expect(page).to have_text(@story_1.title)
      expect(page).to have_text(@story_2.title)
      expect(page).to have_text('ago')
    end

    it 'does not show activities not belonging to the incorrect user' do
      expect(page).to_not have_text(@storybook_3.title)
      expect(page).to_not have_text(@story_3.title)
    end
  end

  context 'there are no activities to render' do
    it 'should render the nothing_to_render_alert partial if there are no activities' do
      visit activities_url

      expect(page).to have_text('Example User')
    end
  end

end