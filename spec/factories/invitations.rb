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

    factory :valid_invitation do
      recipient_email 'valid_invitation@example.com'
    end

    factory :invitation_to_self do
      recipient_email 'self@example.com'
    end

    factory :invitation_already_sent do
      recipient_email 'invited@example.com'
    end

    factory :invitation_to_member do
      recipient_email 'member@example.com'
    end
  end

end