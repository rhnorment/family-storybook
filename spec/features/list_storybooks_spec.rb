require 'rails_helper'

describe 'list storybooks', type: :feature do

  before do
    create_user
    sign_in(@user)
  end

  context 'there are storybooks to render' do
    before do
      create_user_storybooks
      visit storybooks_url
      user2 = User.create!(user_attributes(email: 'user2@example.com'))
      user2.storybooks.create!(storybook_attributes(title: 'Storybook Four Title'))
    end

    it 'shows the storybooks belonging to the correct user' do
      expect(page).to have_text('Storybook Title')
      expect(page).to have_text('Storybook Two Title')
      expect(page).to have_text('Not published')
      expect(page).to have_text('Started')
    end

    it 'does not show storybooks not belonging to the correct user' do
      expect(page).to_not have_text('Storybook Four Title')
    end
  end

  context 'there are no storybooks to render' do
    it 'should render the nothing_to_render_alert partial if there are no storybooks' do
      visit storybooks_url

      expect(page).to have_text('No storybooks to display.')
    end
  end

end