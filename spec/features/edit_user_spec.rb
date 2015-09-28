require 'rails_helper'

describe 'Editing a user', type: :feature do

  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'the edit view is accessible and prompts the user for the right information' do
    it 'updates the user and shows the user updated details' do
      visit user_url(user)

      click_link 'Edit'

      expect(current_path).to eq(edit_user_path(user))

      expect(find_field('Name').value).to eql('Example User')
      expect(find_field('Email').value).to eql('user@example.com')
    end
  end

  describe 'user updates his/her profile' do
    before { visit edit_user_url(user) }

    context 'user enters correct update attributes' do
      it 'updates the record if the update attributes are valid' do
        fill_in 'Name', with: 'Updated User Name'

        click_button 'Update'

        expect(page).to have_text('Updated User Name')
        expect(page).to have_text('Account successfully updated!')
      end
    end

    context 'user enters incorrect update attributes' do
      it 'does not update the user if update attributes are invalid' do
        fill_in 'Name', with: ' '

        click_button 'Update'

        expect(page).to have_text("can't be blank")
      end
    end
  end

end