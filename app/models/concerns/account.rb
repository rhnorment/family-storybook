module Account

  extend ActiveSupport::Concern

  def activate
    return false if !valid?

    self.save

    UserMailer.registration_confirmation(self).deliver_now

    track_activity
  end

end