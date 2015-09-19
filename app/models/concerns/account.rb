module Account

  extend ActiveSupport::Concern

  def activate
    return false if !valid?

    self.active = true

    self.save

    UserMailer.registration_confirmation(self).deliver_now

    track_activity
  end

  def is_active?
    active
  end

  def is_inactive?
    !active
  end

end