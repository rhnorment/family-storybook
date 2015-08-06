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
  end

end