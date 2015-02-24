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

require 'spec_helper'

describe Storybook do

  it 'requires a title' do
    storybook = Storybook.new(title: '')
    storybook.valid?
    expect(storybook.errors[:title].any?).to be_true
  end

  it 'is valid with example attributes' do
    storybook = Storybook.new(storybook_attributes)

    expect(storybook.valid?).to eq(true)
  end

  it 'belongs to a user' do
    user = User.create!(user_attributes)

    storybook = user.storybooks.new(storybook_attributes)

    expect(storybook.user).to eq(user)
  end

end
