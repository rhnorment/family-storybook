# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  relative_id :integer          not null
#  pending     :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base

  include       Trackable

  belongs_to    :user
  belongs_to    :relative,  class_name: 'User'

  validates     :relative_id, uniqueness: { scope: :user_id, message: 'This user is already a family member.' }
  validates     :user_id,  :relative_id,     presence: true

  # returns true if a relationship has been approved, else false:
  def approved?
    !pending
  end

  # returns true if a relationship has not been approved, else false:
  def pending?
    pending
  end

end

# TODO:  add activity tracking for new relationships.
