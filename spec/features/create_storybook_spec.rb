require 'spec_helper'

describe 'create storybook' do

  before do
    user = User.create!(user_attributes)
    sign_in(user)
  end

  it 'saves the storybook and shows its details' do
    visit storybooks_url

    click_link 'Start a new storybook'

    expect(current_path).to eq(new_storybook_path)

    fill_in 'Title', with: 'New Storybook Title'
    fill_in 'Description', with: 'This is my storybook description'

    click_button 'Create my storybook'

    expect(current_path).to eq(storybook_path(Storybook.last))

    expect(page).to have_text('New Storybook Title')
    expect(page).to have_text('Your storybook was successfully created!')
    expect(PublicActivity::Activity.last.trackable.title).to eq(Storybook.last.title)
  end


  it 'does not save the storybook if it is invalid' do
    visit new_storybook_url

    expect { click_button 'Create my storybook' }.to_not change(Storybook, :count)
    expect(page).to have_text('There was a problem creating your storybook.  Please try again')
  end

end