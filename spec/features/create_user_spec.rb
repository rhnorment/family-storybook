require 'rails_helper'

describe 'Creating a new user', type: :feature do

  context 'creating a user without using an invitation token' do
    it 'saves the user and shows the user profile page' do
      ActionMailer::Base.deliveries.clear

      visit root_url

      click_link 'Sign up'

      expect(current_path).to eq(signup_path)

      fill_in 'Name',  with: 'Example User'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'secret'
      fill_in 'Confirm password', with: 'secret'

      click_button 'Register'

      expect(current_path).to eq(user_path(User.last))
      expect(page).to have_text('Example User')
      expect(page).to have_text('Thanks for signing up!')
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(Activity.last.trackable.name).to eq(User.last.name)
    end

    it 'does not save the user if invalid' do
      visit signup_url

      expect {
        click_button 'Register'
      }.not_to change(User, :count)

      expect(page).to have_text("can't be blank")
    end
  end

  context 'creating a user using an invitation token' do
    before do
      Invitation.delete_all
      @inviter = User.create!(user_attributes)
      @invitation = @inviter.invitations.create!(invitation_attributes)
    end

    it 'saves the user and creates a polymorphic relationship with the inviter' do
      visit signup_url(invitation_token: @invitation.token)

      fill_in 'Name',  with: 'Example2 User'
      fill_in 'Email', with: 'tester@example.com'
      fill_in 'Password', with: 'secret'
      fill_in 'Confirm password', with: 'secret'

      click_button 'Register'

      user = User.last

      expect(user.relatives).to include(@inviter)
      expect(Invitation.count).to eq(0)
    end
  end

end
