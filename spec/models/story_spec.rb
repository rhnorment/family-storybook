# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             default("")
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Story, type: :model do

  before { Story.send(:public, *Story.protected_instance_methods) }

  it 'is valid with example attributes' do
    expect(build(:story)).to be_valid
  end

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:user_id) }

  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to have_db_column(:content).of_type(:text) }
  it { is_expected.to have_db_column(:user_id).of_type(:integer) }

  it { is_expected.to have_db_index(:user_id) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:chapters) }
  it { is_expected.to have_many(:storybooks).through(:chapters) }

  it { is_expected.to callback(:track_activity).after(:create) }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:user_id) }

end
