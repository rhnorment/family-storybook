# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  cover        :string(255)
#  published    :boolean          default(FALSE)
#  published_on :datetime
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'faker'

FactoryGirl.define do

  factory :storybook do
    title                    { Faker::Commerce::product_name }
    description              { Faker::Lorem.paragraph }
    cover                   'cover.jpg'
    user
  end

end