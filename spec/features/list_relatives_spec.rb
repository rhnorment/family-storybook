require 'rails_helper'

describe 'list user relatives' do

  let(:user)    { create(:user) }
  let(:user_2)  { create(:user, name: 'User Two', email: 'user_2@example.com') }
  let(:user_3)  { create(:user, name: 'User Three', email: 'user_3@example.com') }
  let(:user_4)  { create(:user, name: 'User Four', email: 'user_4@example.com') }

  before do
    Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false)
    sign_in(user)
  end

  context 'listing approved relationships' do
    it 'lists only approved relationships' do
      visit relationships_url

      expect(page).to have_text(user_2.name)
    end
  end

  context 'not listing any other users' do
    it 'does not list pending relationships' do
      user.invite(user_3)

      visit relationships_url

      expect(page).to_not have_text(user_3.name)
    end

    it 'does not list random users' do
      visit relationships_url

      expect(page).to_not have_text(user_4.name)
    end
  end

end