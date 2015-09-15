require 'rails_helper'

describe 'create storybook', type: :feature do

  before do
    create_user
    sign_in(@user)
  end

  describe ':create action is accessible and prompts the user to enter :create attributes' do
    before do
      visit storybooks_url
      click_link 'Start a new storybook'
    end

    it 'is accessible to the user' do
      expect(current_path).to eql(new_storybook_path)
    end

    it 'prompts the user for the :create attributes' do
      expect(page).to have_field('Title')
      expect(page).to have_field('Description')
      expect(page).to have_button('Create my storybook')
    end
  end

  describe 'user attempts to create a new storybook' do
    before { visit new_storybook_url }

    context 'user enters valid :create attributes' do
      it 'creates and redirects to the new storybook' do
        fill_in 'Title', with: 'Storybook Title'
        fill_in 'Description', with: 'This is my storybook description.'

        click_button 'Create my storybook'

        expect(current_path).to eql(storybook_path(Storybook.last))

        expect(page).to have_text('Storybook Title')
        expect(page).to have_text('This is my storybook description.')
      end
    end

    context 'user enters invalid :create attributes' do
      it 'does not create the new storybook and renders the :create form' do
        fill_in 'Title', with: ''
        fill_in 'Description', with: 'This is my storybook description.'

        click_button 'Create my storybook'

        expect(page).to have_text('There was a problem creating your storybook.  Please try again.')
      end
    end
  end

end