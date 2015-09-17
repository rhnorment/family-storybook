require 'rails_helper'

describe 'invite a relative', type: :feature do

  before do
    create_user
    create_other_users
    sign_in(@user)
    create_user_relationships
  end

  describe 'CREATE action is visible for the appropriate possible relatives' do
    it 'can invite a user via an email invitation' do
      visit new_relationship_url

      expect(page).to have_field('email')
      expect(page).to have_button('Invite')
    end

    it 'is visible for potential relatives' do
      visit new_relationship_url

      expect(page).to have_text('User Four')
      expect(page).to have_text('User Five')
    end

    it 'is not visible for the current user' do
      visit new_relationship_url

      expect(page).to_not have_text('Example User')
    end

    it 'is not visible for current relatives' do
      visit new_relationship_url

      expect(page).to_not have_text('User Two')
      expect(page).to_not have_text('User Three')
    end

    it 'is not visible for users that have been invited by the current user' do
      @user.invite(@user_4)

      visit new_relationship_url

      expect(page).to_not have_text('User Four')
    end

    it 'is not visible for users that have invited the current user' do
      @user_5.invite(@user)

      visit new_relationship_url

      expect(page).to_not have_text('User Five')
    end

  end

  describe 'user creates a relationship'


end