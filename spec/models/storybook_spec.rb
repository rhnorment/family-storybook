# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             default("")
#  cover        :string
#  published    :boolean          default(FALSE)
#  published_on :date
#  user_id      :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

describe Storybook, type: :model do

  before { Storybook.send(:public, *Storybook.protected_instance_methods) }

  it 'is has a valid factory' do
    expect(build(:storybook)).to be_valid
  end

  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to have_db_column(:description).of_type(:text) }
  it { is_expected.to have_db_column(:cover).of_type(:string) }
  it { is_expected.to have_db_column(:published).of_type(:boolean).with_options(default: false) }
  it { is_expected.to have_db_column(:published_on).of_type(:date) }
  it { is_expected.to have_db_column(:user_id).of_type(:integer) }

  it { is_expected.to have_db_index(:user_id) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:chapters) }
  it { is_expected.to have_many(:stories).through(:chapters) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:user_id) }

  it { is_expected.to allow_value('cover.jpg', 'cover.png', 'cover.gif').for(:cover) }

  it { is_expected.to callback(:track_activity).after(:create) }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:cover) }
  it { is_expected.to respond_to(:published) }
  it { is_expected.to respond_to(:published_on) }
  it { is_expected.to respond_to(:user_id) }


end
