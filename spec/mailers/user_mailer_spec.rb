require 'spec_helper'

describe UserMailer do

  context 'when registering for a new account' do

    before do
      @user = User.new(user_attributes(email:'test@example.com'))
    end

    describe 'registration_confirmation' do
      let(:mail) { UserMailer.registration_confirmation(@user) }

      it 'renders the headers' do
        mail.subject.should eq('FamilyBook registration')
        mail.to.should eq([@user.email])
        mail.from.should eq(['no-reply@familybook.com'])
      end

      it 'renders the body' do
        mail.body.encoded.should match(@user.name)
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
        mail.subject.should eq('Password reset')
        mail.to.should eq([@user.email])
        mail.from.should eq(['no-reply@familybook.com'])
      end

      it 'renders the body' do
        mail.body.encoded.should match(CGI::escape(@user.email))
        mail.body.encoded.should match(@user.reset_token)
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
        mail.subject.should eq('Invitation to join FamilyBook!')
        mail.to.should eq([@invitation.recipient_email])
        mail.from.should eq(['no-reply@familybook.com'])
      end

      it 'renders the body' do
        mail.body.encoded.should match(@invitation.user.name)
        mail.body.encoded.should match(@invitation.token)
      end

    end

  end

end
