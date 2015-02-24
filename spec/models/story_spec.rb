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

require 'spec_helper'

describe Story do

  it 'requires a title' do
    story = Story.new(title: '')
    story.valid?
    expect(story.errors[:title].any?).to be_true
  end

  it 'is valid with example attributes' do
    story = Story.new(story_attributes)

    expect(story.valid?).to eq(true)
  end

  it 'belongs to a user' do
    user = User.create!(user_attributes)

    story = user.stories.new(story_attributes)

    expect(story.user).to eq(user)
  end


end
