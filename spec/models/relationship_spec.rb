# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  relative_id :integer
#  pending     :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe 'the relationship model' do

  before do
    @user1 = User.create!(user_attributes) # Jane
    @user2 = User.create!(user_attributes(email: 'user2@example.com')) # David
  end

  it 'should validate the presence of the user and relative ids' do
    relationship = Relationship.new

    expect(relationship.valid?).to be_false
    expect(relationship.errors).to include(:user_id)
    expect(relationship.errors).to include(:relative_id)
    expect(relationship.errors.size).to eq(2)
  end


end
