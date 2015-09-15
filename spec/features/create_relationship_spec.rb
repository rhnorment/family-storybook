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

    end

    it 'is not visible for current relatives' do

    end

    it 'is not visible for users that have been invited by the current user' do

    end

    it 'is not visible for users that have invited the current user' do

    end

  end

  describe 'user creates a relationship'


end