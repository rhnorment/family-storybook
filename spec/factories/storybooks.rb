# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             default("")
#  cover        :string
#  published    :boolean          default(FALSE)
#  published_on :date
#  user_id      :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do

  factory :storybook do
    title
    description   'This is the storybook description.'
    cover         'cover.jpg'
    association   :user, factory: :user
  end

  sequence :title do |n|
    "Storybook-#{n} Title"
  end

end