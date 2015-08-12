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

  before { @user = User.create!(user_attributes) }

  it 'is valid with example attributes' do
    expect(@user.stories.new(story_attributes)).to be_valid
  end

  describe 'ActiveModel validations' do
    # basic validations:
    it { should validate_presence_of(:title) }
  end

  describe 'ActiveRecord associations' do
    # database columns / indexes:
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:content).of_type(:text) }
    it { should have_db_column(:user_id).of_type(:integer) }

    it { should have_db_index(:user_id) }

    # associations:
    it { should belong_to(:user) }
    it { should have_many(:chapters) }
    it { should have_many(:storybooks).through(:chapters) }
    it { should have_many(:activities) }
  end

  context 'callbacks' do
    it { should callback(:create_activity).after(:create) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:create_activity) }
    end

    context 'executes its methods corrects' do
      it 'should create an activity when created' do
        expect(@user.activities.last).to eql(PublicActivity::Activity.last)
      end
    end
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