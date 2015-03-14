require 'spec_helper'

describe 'invite a relative' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'Example User 2'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'Example User 3'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com'))
    sign_in(@user1)
  end


end