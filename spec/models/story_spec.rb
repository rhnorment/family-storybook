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

  before do
    @user = User.create!(user_attributes)
  end

  context 'when creating and editing a story' do
    it 'is valid with example attributes' do
      expect(@user.stories.new(story_attributes)).to be_valid
    end

    it 'is invalid without a title' do
      expect(@user.stories.new(story_attributes(title: nil))).to_not be_valid
    end
  end

  context 'when associating with a user' do
    before do
      @story = @user.stories.create!(story_attributes)
    end

    it 'belongs to a user' do
      expect(@user.stories).to include(@story)
    end

    it 'is destroyed when the user is destroyed' do
      expect { @user.destroy }.to change(Story, :count). by(-1)
    end
  end

  context 'when associating with tracking an activity' do
    it 'creates an associated activity when created'
    it 'deletes the associated activity when deleted'
  end

end