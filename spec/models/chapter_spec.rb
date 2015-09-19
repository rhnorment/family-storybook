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

  describe 'ActiveRecord associations' do
    it { should have_db_column(:storybook_id).of_type(:integer) }
    it { should have_db_column(:story_id).of_type(:integer) }

    it { should belong_to(:storybook) }
    it { should belong_to(:story) }
  end

end
