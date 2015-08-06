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

FactoryGirl.define do

  factory :storybook do
    title            'Example Storybook'
    description      'This is a description of the storybook.'
    cover            'cover.jpg'
    user
  end

end