# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  trackable_id   :integer
#  trackable_type :string
#  owner_id       :integer
#  owner_type     :string
#  recipient_id   :integer
#  recipient_type :string
#  key            :string
#  parameters     :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe Trackable, type: :concern do

  before do
    create_user
    @user.activate
  end

  describe 'tracking a new user registration' do
    before { @activity = @user.activity }

    it 'should add a record to the activites table associated with the user' do
      expect(@user.activities.count).to eql(1)
    end

    it 'should contain the appropriate activity attributes' do
      expect(@activity.trackable_id).to eql(@user.id)
      expect(@activity.trackable_type).to eql('User')
      expect(@activity.owner_id).to eql(@user.id)
      expect(@activity.owner_type).to eql('User')
      expect(@activity.recipient_id).to eql(@user.id)
      expect(@activity.recipient_type).to eql('User')
      expect(@activity.key).to eql('user.create')
    end
  end

  describe 'tracking a storybook creation' do
    before do
      @storybook = @user.storybooks.create!(storybook_attributes)
      @activity = @storybook.activity
    end

    it 'should add a record to the activites table associated with the user' do
      expect(@user.activities.count).to eql(2)  # 1 user creation + 1 storybook creation
    end

    it 'should contain the appropriate activity attributes' do
      expect(@activity.trackable_id).to eql(@storybook.id)
      expect(@activity.trackable_type).to eql('Storybook')
      expect(@activity.owner_id).to eql(@storybook.user.id)
      expect(@activity.owner_type).to eql('User')
      expect(@activity.recipient_id).to eql(@storybook.user.id)
      expect(@activity.recipient_type).to eql('User')
      expect(@activity.key).to eql('storybook.create')
    end
  end

  describe 'tracking a storybook creation' do
    before do
      @story = @user.stories.create!(story_attributes)
      @activity = @story.activity
    end

    it 'should add a record to the activites table associated with the user' do
      expect(@user.activities.count).to eql(2)  # 1 user creation + 1 story creation
    end

    it 'should contain the appropriate activity attributes' do
      expect(@activity.trackable_id).to eql(@story.id)
      expect(@activity.trackable_type).to eql('Story')
      expect(@activity.owner_id).to eql(@story.user.id)
      expect(@activity.owner_type).to eql('User')
      expect(@activity.recipient_id).to eql(@story.user.id)
      expect(@activity.recipient_type).to eql('User')
      expect(@activity.key).to eql('story.create')
    end
  end

end