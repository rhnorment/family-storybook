require 'spec_helper'

describe 'delete a storybook' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'deletes the selected storybook' do
    storybook = @user.storybooks.create!(storybook_attributes)

    visit edit_storybook_url(storybook)

    click_link 'Delete this storybook'

    expect(current_path).to eq(storybooks_path)
    expect(page).not_to have_text(storybook.title)
  end

end