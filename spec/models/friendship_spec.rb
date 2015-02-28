require 'spec_helper'

describe 'the friendship model' do

  before do
    @user1 = User.create!(user_attributes) # Jane
    @user2 = User.create!(user_attributes(email: 'user2@example.com')) # David
  end

  it 'should validate the presence of the user and friend ids' do
      friendship = Amistad.friendship_class.new

      expect(friendship.valid?).to be_false
      expect(friendship.errors).to include(:friendable_id)
      expect(friendship.errors).to include(:friend_id)
      expect(friendship.errors.size).to eq(2)
  end

  context 'when creating friendship' do

    before do
      @user1.invite(@user2)
      @friendship = Amistad.friendship_class.first
    end

    it 'should be pending' do
      expect(@friendship.pending?).to be_true
    end

    it 'should not be approved' do
      expect(@friendship.approved?).to be_false
    end

    it 'should be active' do
      expect(@friendship.active?).to be_true
    end

    it 'should not be blocked' do
      expect(@friendship.blocked?).to be_false
    end

    it 'should be available to block only by invited user' do
      expect(@friendship.can_block?(@user2)).to be_true
      expect(@friendship.can_block?(@user1)).to be_false
    end

    it 'should not be available to unblock' do
      expect(@friendship.can_unblock?(@user1)).to be_false
      expect(@friendship.can_unblock?(@user2)).to be_false
    end

  end

  context 'when approving a friendship' do

    before do
      @user1.invite(@user2)
      @user2.approve(@user1)
      @friendship = Amistad.friendship_class.first
    end

    it 'should be approved' do
      expect(@friendship.approved?).to be_true
    end

    it 'should not be pending' do
      expect(@friendship.pending?).to be_false
    end

    it 'should be active' do
      expect(@friendship.active?).to be_true
    end

    it 'should not be blocked' do
      expect(@friendship.blocked?).to be_false
    end

    it 'should be available to block by both users' do
      expect(@friendship.can_block?(@user1)).to be_true
      expect(@friendship.can_block?(@user2)).to be_true
    end

    it 'should not be available to unblock' do
      expect(@friendship.can_unblock?(@user1)).to be_false
      expect(@friendship.can_unblock?(@user2)).to be_false
    end

  end

  context 'when blocking a friendship' do

    before do
      @user1.invite(@user2)
      @user2.block(@user1)
      @friendship = Amistad.friendship_class.first
    end

    it 'should not be approved' do
      expect(@friendship.approved?).to be_false
    end

    it 'should be pending' do
      expect(@friendship.pending?).to be_true
    end

    it 'should not be active' do
      expect(@friendship.active?).to be_false
    end

    it 'should be blocked' do
      expect(@friendship.blocked?).to be_true
    end

    it 'should not be available to block' do
      expect(@friendship.can_block?(@user1)).to be_false
      expect(@friendship.can_block?(@user2)).to be_false
    end

    it 'should be available to unblock only by user who blocked it' do
      expect(@friendship.can_unblock?(@user1)).to be_false
      expect(@friendship.can_unblock?(@user2)).to be_true
    end

  end

end