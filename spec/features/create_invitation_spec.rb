require 'spec_helper'

describe 'create an invitation to join the site' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  context 'when entering a blank email address' do

    it 'should present an error message and reload the page' do
      visit new_relationship_url

      click_button 'Invite by email'

      expect(current_path).to eq(new_relationship_path)
      expect(page).to have_text('You entered an invalid email address.  Please try again.')
    end

  end

  context 'when entering an invalid email address' do

    it 'should present an error message and reload the page' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: '@org'

      click_button 'Invite by email'

      expect(current_path).to eq(new_relationship_path)
      expect(page).to have_text('You entered an invalid email address.  Please try again.')
    end

  end

  context 'when entering his or her own email address' do

    it 'should present an error message and reload the page' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user@example.com'

      click_button 'Invite by email'

      expect(current_path).to eq(new_relationship_path)
      expect(page).to have_text('You cannot invite yourself.  Please try again')
    end

  end

  context 'when entering an email address of a user who has already considered a relative' do

    before do
      @user2 = User.create!(user_attributes(email: 'user2@example.com', name:'User2 Example'))
      @user.invite @user2
      @user2.approve @user
    end

    it 'should present an information message and redirect to the relationships index page' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button 'Invite by email'

      expect(current_path).to eq(relationships_path)
      expect(page).to have_text('You are already relatives with User2 Example.')
    end

  end

  context 'when entering an email address of a non-existing member that has already been sent an invitation email' do

    before do
      visit new_relationship_url
      fill_in 'invitation[recipient_email]', with: 'user2@example.com'
      click_button 'Invite'
    end

    it 'should notify the user that the recipient has already been invited by email and to contact that person directly' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'
      click_button 'Invite by email'

      expect(current_path).to eq(new_relationship_path)
      expect(page).to have_text('You have already invited user2@example.com.  Please contact this person directly.')
    end

  end

  context 'when entering an email address of an existing member' do

    before do
      @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    end

    it 'should present an information message to the user and reload the page' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button 'Invite by email'

      expect(current_path).to eq(new_relationship_path)
      expect(page).to have_text('user2@example.com is already a member.')
    end

    it 'present the user with the option to invite the member to connect' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button 'Invite by email'

      within('#recipients') do
        expect(page).to have_link('Invite')
      end
    end

  end

  context 'when entering a valid email address of a non-member' do

    it 'should present a success message to the user and reload the page' do
      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button 'Invite by email'

      expect(current_path).to eq(new_relationship_path)
      expect(page).to have_text('Your invitation was sent.')
    end

    it 'should send an email invitation to the recipient' do
      ActionMailer::Base.deliveries.clear

      visit new_relationship_url

      fill_in 'invitation[recipient_email]', with: 'user2@example.com'

      click_button 'Invite by email'

      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end

  end


end