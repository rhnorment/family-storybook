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

  let(:user) { User.create!(user_attributes) }

  it 'is valid with example attributes' do
    expect(user.storybooks.new(storybook_attributes)).to be_valid
  end

  describe 'ActiveModel validations' do
    # basic validations:
    it { should validate_presence_of(:title) }

    # format validations:
    it { should allow_value('cover.jpg', 'cover.png', 'cover.gif').for(:cover) }
  end

  describe 'ActiveRecord associations' do
    # database columns / indexes:
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:cover).of_type(:string) }
    it { should have_db_column(:published).of_type(:boolean).with_options(default: false) }
    it { should have_db_column(:published_on).of_type(:datetime) }
    it { should have_db_column(:user_id).of_type(:integer) }

    it { should have_db_index(:user_id) }

    # associations:
    it { should belong_to(:user) }
    it { should have_many(:chapters) }
    it { should have_many(:stories).through(:chapters) }
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
        expect(user.activities.last).to eql(PublicActivity::Activity.last)
      end
    end
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { should respond_to(:id) }
      it { should respond_to(:title) }
      it { should respond_to(:description) }
      it { should respond_to(:cover) }
      it { should respond_to(:published) }
      it { should respond_to(:published_on) }
      it { should respond_to(:user_id) }
    end
  end

end