#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  recipient_email :string           not null
#  token           :string
#  sent_at         :datetime
#  accepted_at     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do

  factory :invitation do
    association       :user,  factory: :user
    recipient_email   'recipient@example.com'
  end


end