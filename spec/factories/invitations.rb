# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  recipient_email :string(255)
#  token           :string(255)
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do

  factory :invitation do
    recipient_email   'recipient@example.com'
    user
  end

end