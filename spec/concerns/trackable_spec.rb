require 'rails_helper'

describe Trackable, type: :concern do

  describe 'tracking a new user registration' do
    let(:user) { create(:user) }

    before { user.activate }

    let(:activity) { user.activity }

    it 'should add a record to the activites table associated with the user' do
      expect(user.activities.count).to eql(1)
    end

    it 'should contain the appropriate activity attributes' do
      expect(activity.trackable_id).to eql(user.id)
      expect(activity.trackable_type).to eql('User')
      expect(activity.owner_id).to eql(user.id)
      expect(activity.owner_type).to eql('User')
      expect(activity.recipient_id).to eql(user.id)
      expect(activity.recipient_type).to eql('User')
      expect(activity.key).to eql('user.create')
    end
  end

  describe 'tracking a storybook creation' do
    let(:storybook) { create(:storybook) }
    let(:user)      { storybook.user }
    let(:activity)  { storybook.activity }

    it 'should add a record to the activites table associated with the user' do
      expect(user.activities.count).to eql(1)
    end

    it 'should contain the appropriate activity attributes' do
      expect(activity.trackable_id).to eql(storybook.id)
      expect(activity.trackable_type).to eql('Storybook')
      expect(activity.owner_id).to eql(storybook.user.id)
      expect(activity.owner_type).to eql('User')
      expect(activity.recipient_id).to eql(storybook.user.id)
      expect(activity.recipient_type).to eql('User')
      expect(activity.key).to eql('storybook.create')
    end
  end

  describe 'tracking a storybook creation' do
    let(:story)     { create(:story) }
    let(:user)      { story.user }
    let(:activity)  { story.activity }

    it 'should add a record to the activites table associated with the user' do
      expect(user.activities.count).to eql(1)
    end

    it 'should contain the appropriate activity attributes' do
      expect(activity.trackable_id).to eql(story.id)
      expect(activity.trackable_type).to eql('Story')
      expect(activity.owner_id).to eql(story.user.id)
      expect(activity.owner_type).to eql('User')
      expect(activity.recipient_id).to eql(story.user.id)
      expect(activity.recipient_type).to eql('User')
      expect(activity.key).to eql('story.create')
    end
  end

end