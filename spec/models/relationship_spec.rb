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
    create_user
    create_other_users
  end

  it 'is valid with example attributes' do
    expect(Relationship.new(user_id: @user.id, relative_id: @user_2.id)).to be_valid
  end

  describe 'ActiveModel validations' do
    # basic validations:
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:relative_id) }
  end

  describe 'ActiveRecord associations' do
    # database columns:
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:relative_id).of_type(:integer) }
    it { should have_db_column(:pending).of_type(:boolean).with_options(default: true) }

    it { should have_db_index([:user_id, :relative_id]).unique(:true) }

    # associations:
    it { should belong_to(:user) }
    it { should belong_to(:user).class_name('User') }
  end

  context 'callbacks' do
    it 'should callback to create_activity on create'
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { should respond_to(:user_id) }
      it { should respond_to(:relative_id) }
      it { should respond_to(:pending) }
    end
  end

  describe 'public instance methods' do
    context 'respond to its methods' do
      it { should respond_to(:approved?) }
      it { should respond_to(:pending?) }
    end

    context 'method behaves at it should' do
      before do
        @relationship = Relationship.new(user_id: @user.id, relative_id: @user_2.id)
      end

      context '#approved?' do
        it 'should return false if the relationship is not approved' do
          expect(@relationship.approved?).to be_falsey
        end

        it 'should return true if the relationship is approved' do
          @relationship.pending = false
          expect(@relationship.approved?).to be_truthy
        end
      end

      context '#pending?' do
        it 'should return true if the relationship is pending' do
          expect(@relationship.pending?).to be_truthy
        end

        it 'should return false if the relationship is not pending' do
          @relationship.pending = false
          expect(@relationship.pending?).to be_falsey
        end
      end
    end
  end

end



# TODO:  add specs for tracking relationship creations.