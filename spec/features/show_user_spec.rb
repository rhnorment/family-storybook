require 'spec_helper'

describe 'Viewing a user profile page' do

  before do
    @user = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    sign_in(@user)
  end

  it 'shows the user details' do
    visit user_url(@user)

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
    storybook1 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 1'))
    storybook2 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 2'))
    storybook3 = @user2.storybooks.create!(storybook_attributes(title: 'Storybook 3'))

    visit user_url(@user)

    expect(page).to have_text('Storybook 1')
    expect(page).to have_text('Storybook 2')
    expect(page).to have_text('Not published')
    expect(page).to have_text('Started')
    expect(page).to_not have_text('Storybook 3')
  end

  it 'lists the user stories in the stories tab' do
    story1 = @user.stories.create!(story_attributes(title: 'Story 1'))
    story2 = @user.stories.create!(story_attributes(title: 'Story 2'))
    story3 = @user2.stories.create!(story_attributes(title: 'Story 3'))

    visit user_url(@user)

    expect(page).to have_text('Story 1')
    expect(page).to have_text('Story 2')
    expect(page).to have_text('Inclusions')
    expect(page).to have_text('Written')
    expect(page).to_not have_text('Story 3')
  end

  it 'lists the user relationships in the family tab' do
    user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'User 3'))
    user4 = User.create!(user_attributes(email: 'user4@example.com', name: 'User 4'))
    @user.invite(user3)
    user3.approve(@user)

    visit user_url(@user)

    expect(page).to have_text(user3.name)
    expect(page).to have_text('Added as a family member')
    expect(page).to have_link('Remove relative')
    expect(page).to_not have_text(user4.name)
  end

  it 'lists the user activities in the activity tab' do
    storybook = @user.storybooks.create!(storybook_attributes)
    story = @user.stories.create!(story_attributes)

    visit user_url(@user)

    expect(page).to have_text(@user.name)
    expect(page).to have_text(storybook.title)
    expect(page).to have_text(story.title)
    expect(page).to have_text('ago')
  end

end