require 'rails_helper'

describe 'Viewing a user profile page', type: :feature do

  before do
    create_user
    create_other_users
    sign_in(@user)
    create_user_storybooks
    create_user_stories
    create_user_relationships
    visit user_url(@user)
  end

  it 'shows the user details' do
    expect(page).to have_text(@user.name)
    expect(page).to have_text('Storybooks')
    expect(page).to have_text('Stories')
    expect(page).to have_text('Family')
    expect(page).to have_text('Activity')
    expect(page).to have_link('Start a new storybook')
    expect(page).to have_link('Write a new story')
    expect(page).to have_link('Invite a new family member')
    expect(page).to have_link('Edit')
  end

  it 'lists ONLY the user storybooks in the storybooks tab' do
    @user_2.storybooks.create!(storybook_attributes(title: 'Storybook 3'))

    within('#user-storybooks') do
      @user_2.storybooks.create!(storybook_attributes(title: 'Storybook 3'))
      expect(page).to have_text('Storybook Title')
      expect(page).to have_text('Storybook Two Title')
      expect(page).to have_text('Not published')
      expect(page).to have_text('Started')

      expect(page).to_not have_text('Storybook 3')
    end

  end

  it 'lists ONLY the user stories in the stories tab' do
    within('#user-stories') do
      expect(page).to have_text('Story Title')
      expect(page).to have_text('Story Two Title')
      expect(page).to have_text('Inclusions')
      expect(page).to have_text('Written')

      expect(page).to_not have_text('Story 3')
    end
  end

  it 'lists ONLY the most recent family members in the relatives tab' do
    within('#user-relatives') do
      expect(page).to have_text('User Two')
      expect(page).to have_text('User Three')

      expect(page).to_not have_text('User Four')
    end
  end

  it 'lists ONLY the user activities in the activity tab' do
    within('#user-activities') do
      expect(page).to have_text('Storybook Title')
      expect(page).to have_text('Story Title')
      expect(page).to have_text('ago')
    end
  end

end