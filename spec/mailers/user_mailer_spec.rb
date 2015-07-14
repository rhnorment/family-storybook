require 'rails_helper'

describe UserMailer, type: :mailer do

  context 'when registering for a new account' do
    before do
      @user = User.new(user_attributes(email:'test@example.com'))
    end

    describe 'registration_confirmation' do
      let(:mail) { UserMailer.registration_confirmation(@user) }

      it 'renders the headers' do
        expect(mail.subject).to eql('FamilyBook registration')
        expect(mail.to).to eql([@user.email])
        expect(mail.from).to eql(['no-reply@familybook.com'])
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(@user.name)
      end
    end
  end

  context 'when resetting user password' do
    before do
      @user = User.new(user_attributes(email:'test@example.com'))
      @user.reset_token = User.new_token
    end

    describe 'password_reset' do
      let(:mail) { UserMailer.password_reset(@user) }

      it 'renders the headers' do
        expect(mail.subject).to eql('Password reset')
        expect(mail.to).to eql([@user.email])
        expect(mail.from).to eql(['no-reply@familybook.com'])
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(CGI::escape(@user.email))
        expect(mail.body.encoded).to match(@user.reset_token)
      end
    end
  end

  context 'when inviting a non-user to join the site' do
    before do
      user = User.new(user_attributes)
      @invitation = user.invitations.new(invitation_attributes)
      @invitation.token = User.new_token
    end

    describe 'invitation email' do
      let(:mail) { UserMailer.invitation(@invitation) }

      it 'renders the headers' do
        expect(mail.subject).to eql('Invitation to join FamilyBook!')
        expect(mail.to).to eql([@invitation.recipient_email])
        expect(mail.from).to eql(['no-reply@familybook.com'])
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(@invitation.user.name)
        expect(mail.body.encoded).to match(@invitation.token)
      end
    end
  end

end