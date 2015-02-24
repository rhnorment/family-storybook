require 'spec_helper'

describe 'listing a users storys' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'shows the stories belonging to the correct user' do
    story1 = @user.stories.create!(story_attributes(title: 'story 1'))
    story2 = @user.stories.create!(story_attributes(title: 'story 2'))
    story3 = @user.stories.create!(story_attributes(title: 'story 3'))

    visit stories_url

    expect(page).to have_text(story1.title)
    expect(page).to have_text(story2.title)
    expect(page).to have_text(story3.title)
  end

  it 'does not show stories not belonging to the correct user' do
    story1 = @user.stories.create!(story_attributes(title: 'story 1'))
    story2 = @user.stories.create!(story_attributes(title: 'story 2'))
    story3 = @user.stories.create!(story_attributes(title: 'story 3'))

    user2  = User.create!(user_attributes(email: 'user2@example.com'))
    story4 = user2.stories.create!(story_attributes(title: 'story 4'))

    visit stories_url

    expect(page).to have_text(story1.title)
    expect(page).to have_text(story2.title)
    expect(page).to have_text(story3.title)
    expect(page).to_not have_text(story4.title)
  end


end