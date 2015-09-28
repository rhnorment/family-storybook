require 'rails_helper'

describe 'create an invitation to join the site', type: :feature do

  let(:user)      { create(:user) }
  let(:relative)  { create(:relative) }
  let(:invited)   { create(:user, :invited_user) }

  before { sign_in(user) }

  describe 'CREATE action is visible and actionable to the user' do
    before { visit new_relationship_url }

    it 'is visible to the current user' do
      expect(page).to have_field('email')
      expect(page).to have_button('Invite')
    end
  end

  describe 'user attempts to create an invitation' do
    context 'user enters an invalid recipient email address' do
      before { visit new_relationship_url }

      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: '@org'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('You entered an invalid email address.  Please try again.')
      end
    end

    context 'user enters own email address' do
      before { visit new_relationship_url }

      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'user@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('You cannot invite yourself.  Please try again')
      end
    end

    context 'user enters an email address of an approved relative' do
      before do
        Relationship.create!(user_id: user.id, relative_id: relative.id, pending: false)
        visit new_relationship_url
      end

      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'relative@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(relationships_path)
        expect(page).to have_text('You are already relatives with Relative User')
      end

    end

    context 'user enters an email address of an invitee' do
      before do
        Invitation.create!(user_id: user.id, recipient_email: 'invited_user@example.com')
        visit new_relationship_url
      end

      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'invited_user@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('You have already invited invited_user@example.com.  Please contact this person directly.')
      end
    end

    context 'user enters an email address of an existing member' do
      before do
        create(:member)
        visit new_relationship_url
      end

      it 'reloads the form and flashes an en error message' do
        fill_in 'invitation[recipient_email]', with: 'member_user@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('member_user@example.com is already a member.')
      end
    end

    context 'user enters a valid email address to a valid recipient' do
      before { visit new_relationship_url }

      it 'should present a success message to the user and reload the page' do
        fill_in 'invitation[recipient_email]', with: 'want_to_connect@example.com'

        click_button 'Invite by email'

        expect(current_path).to eq(new_relationship_path)
        expect(page).to have_text('Your invitation was sent.')
      end
    end
  end

end