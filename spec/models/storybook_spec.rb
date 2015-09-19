# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             default("")
#  cover        :string
#  published    :boolean          default(FALSE)
#  published_on :date
#  user_id      :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

describe Storybook, type: :model do

  before do
    Storybook.send(:public, *Storybook.protected_instance_methods)
    create_user
  end

  it 'is valid with example attributes' do
    expect(@user.storybooks.new(storybook_attributes)).to be_valid
  end

  describe 'ActiveRecord' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:cover).of_type(:string) }
    it { should have_db_column(:published).of_type(:boolean).with_options(default: false) }
    it { should have_db_column(:published_on).of_type(:date) }
    it { should have_db_column(:user_id).of_type(:integer) }

    it { should have_db_index(:user_id) }

    it { should belong_to(:user) }
    it { should have_many(:chapters) }
    it { should have_many(:stories).through(:chapters) }
  end

  describe 'ActiveModel' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user_id) }

    it { should allow_value('cover.jpg', 'cover.png', 'cover.gif').for(:cover) }
  end

  context 'callbacks' do
    it { should callback(:track_activity).after(:create) }
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
