require 'spec_helper'

describe 'delete a story' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'deletes the selected story' do
    story = @user.stories.create!(story_attributes)

    visit edit_story_url(story)

    click_link 'Delete this story'

    expect(current_path).to eq(stories_path)
    expect(page).not_to have_text(story.title)
  end

end