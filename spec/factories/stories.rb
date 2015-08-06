# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do

  factory :story do
    title     'Example Story'
    content   'This is the content of the example story.'
    user
  end

end