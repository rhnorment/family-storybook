# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  cover        :string(255)
#  published    :boolean          default(FALSE)
#  published_on :datetime
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

describe Storybook, type: :model do

  context 'when creating and editing a storybook' do
    it 'is has a valid factory' do
      expect(build(:user_with_storybooks)).to be_valid
    end

    it { should validate_presence_of(:title) }
  end

  context 'when associating with other objects' do
    it { should belong_to(:user) }

    it { should have_many(:activities).dependent(:destroy) }

    it { should have_many(:chapters).dependent(:destroy) }

    it { should have_many(:stories).through(:chapters) }
  end

end