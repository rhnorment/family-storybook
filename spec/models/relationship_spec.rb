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

require 'rails_helper'

describe Relationship, type: :model do
  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
  end

  it 'should validate the presence of the user and relative ids' do
    relationship = Relationship.new

    expect(relationship).to_not be_valid
    expect(relationship.errors).to include(:user_id)
    expect(relationship.errors).to include(:relative_id)
    expect(relationship.errors.size).to eq(2)
  end

  context 'when creating a new relationship' do
    before do
      @user1.invite(@user2)
      @relationship = Relationship.first
    end

    it 'should be pending' do
      expect(@relationship.pending?).to eql(true)
    end

    it 'should not be approved' do
      expect(@relationship.approved?).to eql(false)
    end
  end

  context 'when approving a relationship' do
    before do
      @user1.invite(@user2)
      @user2.approve(@user1)
      @relationship = Relationship.first
    end

    it 'should be approved' do
      expect(@relationship.approved?).to eql(true)
    end

    it 'should not be pending' do
      expect(@relationship.pending?).to eql(false)
    end
  end

  context 'when removing a relationship' do
    before do
      @user1.invite(@user2)
      @user2.approve(@user1)
      @relationship = Relationship.first
      @user1.remove_relationship(@user2)
    end

    it 'the relationship record should not exist' do
      expect(Relationship.all.size).to eq(0)
    end
  end

end

# TODO:  add specs for tracking relationship creations.