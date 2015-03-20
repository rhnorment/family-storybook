require 'spec_helper'

describe 'editing a relationship' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'Example User 2'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'Example User 3'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com', name: 'Example User 4'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com', name: 'Example User 5'))
    sign_in(@user1)
  end

  context 'accepting an incoming invitation request' do

    before do
      @user2.invite(@user1)
      @user3.invite(@user1)
      @user4.invite(@user1)
      @user5.invite(@user1)
      @user1.approve(@user5)
    end

    it 'lists the pending incoming relationships requests' do
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
      visit pending_relationships_url

      expect(page).to_not have_text(@user5.name)
    end

    it 'allows the user to approve the invitation and return to the incoming relationship page' do
      visit pending_relationships_url

      click_link('Approve', { href: relationship_path(@user2) })

      expect(current_path).to eq(pending_relationships_path)
      expect(page).to have_text('Your family member was added.')
      expect(@user1.relatives.size).to eq(2)
    end

  end

  context 'when cancelling an outgoing relationship request' do

    before do
      @user1.invite(@user2)
      @user1.invite(@user3)
      @user1.invite(@user4)
      @user1.invite(@user5)
      @user5.approve(@user1)
    end

    it 'lists the pending outgoing relationships requests' do
      visit pending_relationships_url

      within('#pending-outgoing') do
        expect(page).to have_text(@user2.name)
        expect(page).to have_text(@user3.name)
        expect(page).to have_text(@user4.name)
        expect(page).to have_text('Invitation sent')
        expect(page).to have_link('Cancel')
      end
    end

    it 'does not list already approved relationships' do
      visit pending_relationships_url

      expect(page).to_not have_text(@user5.name)
    end

    it 'allows the user to approve the invitation and return to the incoming relationship page' do
      visit pending_relationships_url

      click_link('Cancel', { href: relationship_path(@user2) })

      expect(current_path).to eq(relationships_path)
      expect(page).to have_text('Your family member was removed.')
      expect(@user1.relatives.size).to eq(1)
    end

  end

end