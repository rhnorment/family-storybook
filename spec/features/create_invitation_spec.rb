require 'rails_helper'

describe 'create an invitation to join the site', type: :feature do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
    create_other_users
    create_user_relationships
    create_user_invitations
    visit new_relationship_url
  end

  describe 'CREATE action is visible and actionable to the user' do
    it 'is visible to the current user' do
      expect(page).to have_field('email')
      expect(page).to have_button('Invite')
    end
  end

  describe 'user attempts to create an invitation' do
    context 'user enters an invalid recipient email address' do
      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: '@org'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('You entered an invalid email address.  Please try again.')
      end
    end

    context 'user enters own email address' do
      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'user@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('You cannot invite yourself.  Please try again')
      end
    end

    context 'user enters an email address of an approved relative' do
      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'user_2@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(relationships_path)
        expect(page).to have_text('You are already relatives with User Two.')
      end

    end

    context 'user enters an email address of an invitee' do
      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'invitee@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('You have already invited invitee@example.com.  Please contact this person directly.')
      end
    end

    context 'user enters an email address of an existing member' do
      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'user_4@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('user_4@example.com is already a member.')
      end
    end

    context 'user enters a valid email address to a valid recipient' do
      it 'should present a success message to the user and reload the page' do
        fill_in 'invitation[recipient_email]', with: 'want_to_connect@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('Your invitation was sent.')
      end
    end
  end

end