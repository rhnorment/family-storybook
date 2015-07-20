require 'rails_helper'

describe 'invite a relative', type: :feature do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'User2'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'User3'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com', name: 'User4'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com', name: 'User5'))
    sign_in(@user1)
  end

  it 'should display a list of recommended users to invite, each with a link to invite and an email address form' do
    visit new_relationship_url

    expect(page).to have_field('email')
    expect(page).to have_button('Invite')

    expect(page).to have_text(@user2.name)
    expect(page).to have_text(@user3.name)
    expect(page).to have_text(@user4.name)
    expect(page).to have_text(@user5.name)
    expect(page).to have_text('Joined')
    expect(page).to have_link('Invite')
  end

  it 'should not display the current user' do
    visit new_relationship_url

    within('#invitees') do
      expect(page).to_not have_text(@user1.name)
    end
  end

  it 'should not display users that are already relatives' do
    @user1.invite(@user2)
    @user2.approve(@user1)

    visit new_relationship_url

    within('#invitees') do
      expect(page).to_not have_text(@user2.name)
    end
  end

  it 'should not display users that have already been invited' do
    @user1.invite(@user2)
    @user1.invite(@user3)

    visit new_relationship_url

    within('#invitees') do
      expect(page).to_not have_text(@user2.name)
      expect(page).to_not have_text(@user3.name)
    end
  end

  context 'when inviting a recommended family member to connect via the recommended relative list' do
    before do
      Relationship.delete_all
    end

    it 'should invite other users to be family members' do
      visit new_relationship_url

      expect(page).to have_text(@user2.name)

      click_link('Invite', { href: relationships_path(user_id: @user2) })

      expect(current_url).to eq(new_relationship_url)
      expect(page).to_not have_text(@user2.name)
    end
  end

  context 'when confirming a relationship request from within the system' do
    before do
      @user2.invite(@user1)
    end

    it 'should allow the user to confirm the relationship' do
      visit pending_relationships_url

      expect(page).to have_text(@user2.name)

      click_link('Confirm')

      expect(current_path).to eq(pending_relationships_path)
      expect(page).to have_text('User2 is now a relative')
    end
  end

end