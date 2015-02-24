require 'spec_helper'

describe 'list storybooks' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'shows the storybooks belonging to the correct user' do
    storybook1 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 1'))
    storybook2 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 2'))
    storybook3 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 3'))

    visit storybooks_url

    expect(page).to have_text(storybook1.title)
    expect(page).to have_text(storybook2.title)
    expect(page).to have_text(storybook3.title)
  end

  it 'does not show storybooks not belonging to the correct user' do
    storybook1 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 1'))
    storybook2 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 2'))
    storybook3 = @user.storybooks.create!(storybook_attributes(title: 'Storybook 3'))

    user2  = User.create!(user_attributes(email: 'user2@example.com'))
    storybook4 = user2.storybooks.create!(storybook_attributes(title: 'storybook 4'))

    visit storybooks_url

    expect(page).to have_text(storybook1.title)
    expect(page).to have_text(storybook2.title)
    expect(page).to have_text(storybook3.title)
    expect(page).to_not have_text(storybook4.title)
  end


end