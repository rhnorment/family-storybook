class UserMailer < ActionMailer::Base

  default from: 'no-reply@familybook.com'

  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'FamilyBook registration'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def invitation(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: 'Invitation to join FamilyBook!'
  end

end
