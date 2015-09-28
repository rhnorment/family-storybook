require 'rails_helper'

describe 'edit a storybook', type: :feature do

  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'the edit view is accessible and prompts the user for the right attributes' do
    before do
      @storybook_1 = create(:storybook, user: user)

      visit storybook_url(@storybook_1)
    end

    it 'updates the storybooks and shows the updated attributes' do
      click_link 'Edit this storybook'

      expect(current_path).to eq(edit_storybook_path(@storybook_1))
      expect(page).to have_field('Title')
      expect(page).to have_field('Description')
      expect(page).to have_field('Cover')
      expect(page).to have_link('Publish this storybook')
      expect(page).to have_link('Delete this storybook')
    end
  end

  describe 'user updates the storybook' do
    before do
      @storybook_1 = create(:storybook, user: user)
      @story_1 = create(:story, user: user)
      @story_2 = create(:story, user: user)

      visit edit_storybook_url(@storybook_1)
    end

    context 'user enters correct update attributes' do
      it 'updates the storybook with the input parameters' do
        fill_in 'Title', with: 'Updated Title'
        fill_in 'Description', with: 'Updated description'
        attach_file 'Cover', 'spec/support/uploads/redsherpalogo3.png'
        check(@story_1.title)
        check(@story_2.title)

        click_button 'Update my storybook'

        expect(page).to have_text('Updated Title')
        expect(page).to have_text('Updated description')
        expect(page).to have_selector("img[src$='#{@storybook_1.cover_url}']")
        expect(page).to have_text(@story_1.title)
        expect(page).to have_text(@story_2.title)
      end
    end

    context 'user enters incorrect update attributes' do
      it 'does not update a storybook with a blank title' do
        fill_in 'Title', with: ' '
        fill_in 'Description', with: 'Updated description'
        attach_file 'Cover', 'spec/support/uploads/redsherpalogo3.png'
        click_button 'Update my storybook'

        expect(page).to have_text('There was a problem updating your storybook.  Please try again.')
      end

      it 'does not update a storybook with an invalid cover file' do
        attach_file 'Cover', 'spec/support/uploads/sherpa.pdf'
        click_button 'Update my storybook'

        expect(page).to have_text('There was a problem updating your storybook.  Please try again.')
      end
    end
  end

end