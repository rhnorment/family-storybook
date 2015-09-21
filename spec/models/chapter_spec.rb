# == Schema Information
#
# Table name: chapters
#
#  id           :integer          not null, primary key
#  storybook_id :integer          not null
#  story_id     :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

describe Chapter, type: :model do

  it { is_expected.to have_db_column(:story_id).of_type(:integer) }
  it { is_expected.to have_db_column(:storybook_id).of_type(:integer) }

  it { is_expected.to belong_to(:story) }
  it { is_expected.to belong_to(:storybook) }

  it { is_expected.to validate_presence_of(:story_id) }
  it { is_expected.to validate_presence_of(:storybook_id) }

end
