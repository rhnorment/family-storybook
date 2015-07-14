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

  before do
    @user = User.create!(user_attributes)
  end

  context 'when creating and editing a storybook' do
    it 'has is valid with example attributes' do
      expect(@user.storybooks.new(storybook_attributes)).to be_valid
    end

    it 'is invalid without a title' do
      expect(@user.storybooks.new(storybook_attributes(title: nil))).to_not be_valid
    end
  end

  context 'when associating with a user' do
    before do
      @storybook = @user.storybooks.create!(storybook_attributes)
    end

    it 'belongs to a user' do
      expect(@user.storybooks).to include(@storybook)
    end

    it 'is destroyed when the user is destroyed' do
      expect { @user.destroy }.to change(Storybook, :count). by(-1)
    end
  end

  context 'when associating with tracking an activity' do
    it 'creates an associated activity when created'
    it 'deletes the associated activity when deleted'
  end

end