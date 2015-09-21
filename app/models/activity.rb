# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  trackable_id   :integer
#  trackable_type :string
#  owner_id       :integer
#  owner_type     :string
#  recipient_id   :integer
#  recipient_type :string
#  key            :string
#  parameters     :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Activity < ActiveRecord::Base

  belongs_to :owner,      polymorphic: true
  belongs_to :recipient,  polymorphic: true
  belongs_to :trackable,  polymorphic: true

end
