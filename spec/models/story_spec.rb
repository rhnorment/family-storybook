# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Story, type: :model do

  context 'when creating and editing a story' do
    it 'has a valid factory' do
      expect(build(:user_with_stories)).to be_valid
    end

    it { should validate_presence_of(:title) }
  end

  context 'when associating with other objects' do
    it { should belong_to(:user) }

    it { should have_many(:activities).dependent(:destroy) }

    it { should have_many(:chapters).dependent(:destroy) }

    it { should have_many(:storybooks).through(:chapters) }
  end

end