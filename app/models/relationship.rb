# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  relative_id :integer
#  pending     :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base

  # model validations:
  validates             :user_id,  :relative_id,     presence: true
  validates             :relative_id, uniqueness: { scope: :user_id, message: 'This user is already a family member.' }

  # data relationships:
  belongs_to            :user
  belongs_to            :relative,     class_name: 'User'

  # returns true if a relationship has been approved, else false:
  def approved?
    !self.pending
  end

  # returns true if a relationship has not been approved, else false:
  def pending?
    self.pending
  end

end
