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

FactoryGirl.define do

  factory :relationship do
    association     :user,      factory: :user
    association     :relative,  factory: :relative
    pending         true
  end

end