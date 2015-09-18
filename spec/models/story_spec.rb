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
    Story.send(:public, *Story.protected_instance_methods)
    create_user
  end

  it 'is valid with example attributes' do
    expect(@user.stories.new(story_attributes)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'ActiveRecord associations' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:content).of_type(:text) }
    it { should have_db_column(:user_id).of_type(:integer) }

    it { should have_db_index(:user_id) }

    it { should belong_to(:user) }
    it { should have_many(:chapters) }
    it { should have_many(:storybooks).through(:chapters) }
  end

  context 'callbacks' do
    it { should callback(:track_activity).after(:create) }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { should respond_to(:id) }
      it { should respond_to(:title) }
      it { should respond_to(:content) }
      it { should respond_to(:user_id) }
    end
  end

end