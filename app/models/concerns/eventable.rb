module Eventable

  extend  ActiveSupport::Concern

  include PublicActivity::Common

  #  creates a record in the activities when an instance of a model object is created
  def create_activity
    PublicActivity::Activity.create   key: "#{class_name.downcase}.create", trackable_id: self.id, trackable_type: class_name,
                                      recipient_id: owner_id, recipient_type: 'User', owner_id: owner_id, owner_type: 'User',
                                      created_at: self.created_at, parameters: {}
  end

  def class_name
    self.class.name
  end

  def owner_id
    self.class == User ? self.id : self.user.id
  end

end