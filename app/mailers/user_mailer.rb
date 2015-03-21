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

  def invitation_to_connect(user, invitee)
    @user = user
    invitee = invitee
    mail to: invitee.email, subject: 'Invitation to connect on FamilyBook'
  end

  def invitation_to_join(user, invitee)
    @user = user
    @invitee = invitee
    mail to: invitee.email, subject: 'Invitation to join FamilyBook'
  end

end
