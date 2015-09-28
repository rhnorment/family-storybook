require 'rails_helper'

describe 'invite a relative', type: :feature do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, name: 'User Two', email: 'user_2@example.com') }
  let(:user_4)  { create(:user, name: 'User Four', email: 'user_4@example.com') }
  let(:user_5)  { create(:user, name: 'User Five', email: 'user_5@example.com') }

  before do
    sign_in(user)
    @user_3 = create(:user, name: 'User Three', email: 'user_3@example.com')
    Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false)
    user.invite(user_4)
    user_5.invite(user)
  end

  describe 'CREATE action is visible for the appropriate possible relatives' do
    it 'can invite a user via an email invitation' do
      visit new_relationship_url

      expect(page).to have_field('email')
      expect(page).to have_button('Invite')
    end

    it 'is visible for prospective relatives' do
      visit new_relationship_url

      expect(page).to have_text(@user_3.name)
    end

    it 'is not visible for the current user' do
      visit new_relationship_url

      expect(page).to_not have_text('Example User')
    end

    it 'is not visible for current relatives' do
      visit new_relationship_url

      expect(page).to_not have_text(user_2.name)
    end

    it 'is not visible for users that have been invited by the current user' do
      visit new_relationship_url

      expect(page).to_not have_text(user_4.name)
    end

    it 'is not visible for users that have invited the current user' do
      visit new_relationship_url

      expect(page).to_not have_text(user_5.name)
    end

  end

  describe 'user creates a relationship'


end