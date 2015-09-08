require 'rails_helper'

describe Trackable, type: :concern do

  describe 'tracking a new user registration' do
    before do
      PublicActivity::Activity.delete_all
      create_user
    end

    it 'should add a new trackable activity' do
      expect(PublicActivity::Activity.count).to eql(1)
    end
  end


end