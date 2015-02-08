class UserMailer < ActionMailer::Base

  default :from => 'no-reply@familyshare.com'

  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'FamilyShare Registration'
  end

end
