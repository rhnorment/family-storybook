# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  trackable_id   :integer
#  trackable_type :string
#  owner_id       :integer
#  owner_type     :string
#  recipient_id   :integer
#  recipient_type :string
#  key            :string
#  parameters     :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe Activity, type: :model do

  it { should have_db_column(:trackable_id).of_type(:integer) }
  it { should have_db_column(:trackable_type).of_type(:string) }
  it { should have_db_column(:owner_id).of_type(:integer) }
  it { should have_db_column(:owner_type).of_type(:string) }
  it { should have_db_column(:recipient_id).of_type(:integer) }
  it { should have_db_column(:recipient_type).of_type(:string) }
  it { should have_db_column(:key).of_type(:string) }
  it { should have_db_column(:parameters).of_type(:text) }

  it { should have_db_index([:trackable_id, :trackable_type]) }
  it { should have_db_index([:owner_id, :owner_type]) }
  it { should have_db_index([:recipient_id, :recipient_type]) }

  it { should belong_to(:trackable) }
  it { should belong_to(:owner) }
  it { should belong_to(:recipient) }

end
