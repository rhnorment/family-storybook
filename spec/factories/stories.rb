# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             default("")
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do

  factory :story do
    title         { generate(:story_title) }
    content       'This is the content of the story.'
    association   :user, factory: :user
  end

  sequence :story_title do |n|
    "Story-#{n} Title"
  end

end