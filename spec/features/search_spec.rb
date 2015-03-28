require 'spec_helper'

describe 'Search' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
    @storybook1 = @user.storybooks.create!(storybook_attributes(title: 'First Storybook',
                                                                description: 'First storybook description.'))
    @storybook2 = @user.storybooks.create!(storybook_attributes(title: 'Second Storybook',
                                                                description: 'Second storybook description.'))
    @story1 = @user.stories.create!(story_attributes(title: 'First Story', content: 'Content of first story.'))
    @story2 = @user.stories.create!(story_attributes(title: 'Second Story', content: 'Content of second story.'))
  end

  it 'presents a search form to the user on all application pages' do
    visit storybooks_url

    expect(page).to have_field('query')
  end

  it 'returns an empty array with a message if an empty form is submitted' do
    visit stories_url

    fill_in 'query', with: ' '
    click_button 'Submit'

    expect(page).to have_text('No results to display.')
  end

  it 'returns an empty array if the search results are nil' do
    visit storybooks_url

    fill_in 'query', with: 'hunt'
    click_button 'Submit'

    expect(page).to have_text('No results to display.')
  end

  context 'when returning an array consisting items' do

    it 'returns the correct array of results' do
      visit stories_url

      fill_in 'query', with: 'storybook'
      click_button 'Submit'

      expect(page).to have_link(@storybook1.title)
      expect(page).to have_link(@storybook2.title)
      expect(page).to have_link('Storybook')
      expect(page).to have_text(@storybook1.user.name)
      expect(page).to have_text('created')
    end

    it 'does not return an incorrect array of results' do
      visit storybooks_url

      fill_in 'query', with: 'story'
      click_button 'Submit'

      expect(page).to_not have_link(@storybook1.title)
      expect(page).to_not have_link(@storybook2.title)
    end

  end


end