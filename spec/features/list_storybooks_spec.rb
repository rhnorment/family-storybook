require 'rails_helper'

describe 'list storybooks', type: :feature do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, email: 'user_2@example.com') }

  before { sign_in(user) }

  context 'there are storybooks to render' do
    before do
      @storybook_1 = create(:storybook, user: user)
      @storybook_2 = create(:storybook, user: user)
      @storybook_3 = create(:storybook, user: user_2)

      visit storybooks_url
    end

    it 'shows the storybooks belonging to the correct user' do
      expect(page).to have_text(@storybook_1.title)
      expect(page).to have_text(@storybook_2.title)
      expect(page).to have_text('Not published')
      expect(page).to have_text('Started')
    end

    it 'does not show storybooks not belonging to the correct user' do
      expect(page).to_not have_text(@storybook_3.title)
    end
  end

  context 'there are no storybooks to render' do
    it 'should render the nothing_to_render_alert partial if there are no storybooks' do
      visit storybooks_url

      expect(page).to have_text('No storybooks to display.')
    end
  end

end