require 'spec_helper'

describe 'editing a relationship' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'Example User 2'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'Example User 3'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com'))
    sign_in(@user1)
  end

  it 'lists the pending outgoing relationships requests' do
    @user1.invite(@user2)
    @user1.invite(@user3)
    @user1.invite(@user4)

    visit pending_relationships_url

    within('#pending-outgoing') do
      expect(page).to have_text(@user2.name)
      expect(page).to have_text(@user3.name)
      expect(page).to have_text(@user4.name)
      expect(page).to have_text('Invitation sent')
      expect(page).to have_link('Cancel')
    end
  end

  it 'lists the pending incoming relationships requests' do
    @user2.invite(@user1)
    @user3.invite(@user1)
    @user4.invite(@user1)

    visit pending_relationships_url

    within('#pending-incoming') do
      expect(page).to have_text(@user2.name)
      expect(page).to have_text(@user3.name)
      expect(page).to have_text(@user4.name)
      expect(page).to have_text('Invitation sent')
      expect(page).to have_link('Approve')
    end
  end

  it 'does not list already approved relationships' do
    @user1.invite(@user2)
    @user1.invite(@user3)
    @user3.approve(@user1)

    visit pending_relationships_url

    expect(page).to_not have_text(@user3.name)
  end

  # TODO:  add contexts for relationship states and actions

end