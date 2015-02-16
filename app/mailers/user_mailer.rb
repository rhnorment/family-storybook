class UserMailer < ActionMailer::Base

  default :from => 'no-reply@familyshare.com'

  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'FamilyBook registration'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

end
