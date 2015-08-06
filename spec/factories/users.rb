# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  reset_token     :string(255)
#  reset_sent_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime


FactoryGirl.define do

  factory :user do
    name                    'Example User'
    email                   'user@example.com'
    password                'secret'
    password_confirmation   'secret'

    factory :user_with_storybooks do
      transient do
        storybooks_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:storybook, evaluator.storybooks_count, user: user)
      end
    end

    factory :user_with_stories do
      transient do
        stories_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:story, evaluator.stories_count, user: user)
      end
    end
  end

end