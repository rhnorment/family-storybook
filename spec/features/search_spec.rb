require 'rails_helper'

describe 'Search', type: :feature do

  before do
    create_user
    sign_in(@user)
    create_user_storybooks
    create_user_stories
   end

  it 'presents a search form to the user on all application pages' do
    visit storybooks_url

    expect(page).to have_field('query')
  end

  describe 'user is searching for a storybook or story' do
    context 'user enters an empty search' do
      it 'returns an empty array with a message if an empty form is submitted' do
        visit stories_url

        fill_in 'query', with: ' '
        click_button 'Submit'

        expect(page).to have_text('No results to display.')
      end
    end

    context 'search results are nil' do
      it 'returns an empty array if the search results are nil' do
        visit storybooks_url

        fill_in 'query', with: 'hunt'
        click_button 'Submit'

        expect(page).to have_text('No results to display.')
      end
    end

    context 'when returning an array consisting items' do
      it 'returns the correct array of results' do
        visit stories_url

        fill_in 'query', with: 'storybook'
        click_button 'Submit'

        expect(page).to have_link('Storybook Title')
        expect(page).to have_link('Storybook Two Title')
        expect(page).to have_link('Storybook')
        expect(page).to have_text('Example User')
        expect(page).to have_text('created')
      end

      it 'does not return an incorrect array of results' do
        visit storybooks_url

        fill_in 'query', with: 'story'

        click_button 'Submit'

        expect(page).to_not have_link('Storybook Title')
        expect(page).to_not have_link('Storybook Two Title')
      end
    end
  end

end