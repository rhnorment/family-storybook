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
    it 'has a valid factory' do
      expect(build(:storybook)).to be_valid
    end

    it 'is invalid without a title' do
      expect(build(:storybook, title: nil)).to_not be_valid
    end
  end

  context 'when associating with a user object' do
    it 'belongs to a user' do
      user = create(:user)
      storybook = user.storybooks.build(title: 'Example Storybook', user_id: user.id)
      expect(storybook.user).to eql(user)
    end
  end

end