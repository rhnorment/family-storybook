module Trackable

  extend ActiveSupport::Concern

  included do
    has_one   :activity,  as: :trackable
  end

  def track_activity
    Activity.create(trackable: self, owner: owner_and_recipient, recipient: owner_and_recipient, key: "#{self.class.name.downcase}.create")
  end

  protected

    def owner_and_recipient
      if self.class.name == 'User'
        self
      else
        self.user
      end
    end

end