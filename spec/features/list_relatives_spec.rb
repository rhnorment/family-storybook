require 'rails_helper'

describe 'list user relatives' do

  before do
    create_user
    create_other_users
    sign_in(@user)
    create_user_relationships
  end

  context 'listing approved relationships' do
    it 'lists only approved relationships' do
      visit relationships_url

      expect(page).to have_text('User Two')
      expect(page).to have_text('User Three')
    end
  end

  context 'not listing any other users' do
    it 'does not list pending relationships' do
      @user.invite(@user_4)
      @user_5.invite(@user)

      visit relationships_url

      expect(page).to_not have_text('User Four')
      expect(page).to_not have_text('User Five')
    end

    it 'does not list random users' do
      User.create!(user_attributes(name: 'User Six', email: 'user_6@example.com'))

      visit relationships_url

      expect(page).to_not have_text('User Six')
    end
  end

end