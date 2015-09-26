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

  it 'has a valid factory' do
    expect(build(:story)).to be_valid
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }

  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:content).of_type(:text) }
  it { should have_db_column(:user_id).of_type(:integer) }

  it { should have_db_index(:user_id) }

  it { should belong_to(:user) }
  it { should have_many(:chapters) }
  it { should have_many(:storybooks).through(:chapters) }

  it { should callback(:track_activity).after(:create) }

  it { should respond_to(:id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

end
