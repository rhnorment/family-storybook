require 'spec_helper'

describe 'listing a users activities' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'shows the user activities belonging to the correct user' do
    storybook = @user.storybooks.create!(storybook_attributes)
    story = @user.stories.create!(story_attributes)

    visit activities_url

    expect(page).to have_text(storybook.title)
    expect(page).to have_text(story.title)
  end

  it 'does not show activities not belonging to the incorrect user' do
    storybook = @user.storybooks.create!(storybook_attributes)
    story = @user.stories.create!(story_attributes)

    user2 = User.create!(user_attributes(email: 'user2@example.com'))
    storybook2 = user2.storybooks.create!(storybook_attributes(title: 'Storybook 2'))
    story2 = user2.stories.create!(story_attributes(title: 'Story 2'))

    visit activities_url

    expect(page).to have_text(storybook.title)
    expect(page).to have_text(story.title)
    expect(page).to_not have_text(storybook2.title)
    expect(page).to_not have_text(story2.title)
  end

end