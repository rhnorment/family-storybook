
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  reset_token     :string
#  reset_sent_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  active          :boolean          default(FALSE)
#

FactoryGirl.define do

  factory :user do
    name                    'Example User'
    email                   'user@example.com'
    password                'secret'
    password_confirmation   'secret'
    active                  true

    trait :new_user do
      name                  'New User'
      email                 'new_user@example.com'
    end

    trait :bad_user do
      name                  'Bad User'
      email                 nil
    end

    trait :inactive_user do
      name                  'Inactive User'
      email                 'inactive_user@example.com'
      active                false
    end

    trait :wrong_user do
      name                  'Wrong User'
      email                 'wrong_user@example.com'
    end

    trait :member_user do
      name                  'Member User'
      email                 'member_user@example.com'
    end

    trait :invited_user do
      name                  'Invited User'
      email                 'invited_user@example.com'
    end
  end

  factory :relative, class: User do
    name                    'Relative User'
    email                   'relative@example.com'
    password                'secret'
    password_confirmation   'secret'
    active                  true
  end

  factory :member, class: User do
    name                    'Member User'
    email                   'member_user@example.com'
    password                'secret'
    password_confirmation   'secret'
    active                  true
  end

end