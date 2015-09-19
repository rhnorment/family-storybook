module Account

  extend ActiveSupport::Concern

  def activate
    return false if !valid?

    self.active = true

    self.save

    UserMailer.registration_confirmation(self).deliver_now

    track_activity
  end

  def deactivate
    return false if !self

    self.update!(active: false)

    UserMailer.deactivation_confirmation(self).deliver_now
  end

  def is_active?
    active
  end

  def is_inactive?
    !active
  end

end