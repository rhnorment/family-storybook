require 'spec_helper'

describe 'listing relationships' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com'))
    sign_in(@user1)
  end

  it 'should list all the approved relationships and allow the user to remove the relationship' do
    expect(@user1.invite(@user2)).to be_true    # john invites jane
    expect(@user3.invite(@user1)).to be_true    # peter invites john
    expect(@user1.invite(@user4)).to be_true    # john invites james
    expect(@user4.approve(@user1)).to be_true   # james approves john
    expect(@user5.invite(@user1)).to be_true    # mary invites john
    expect(@user1.approve(@user5)).to be_true   # john approves mary

    visit relationships_url


  end

  it 'should list pending relationships invited by the user and allow the user to remove the relationship'

  it 'should list pending relationships that have invited the user and allow the user to approve the invitation'

  it 'should render the nothing_to_render_alert partial if there are no relatives' do
    visit relationships_url

    expect(page).to have_text('There are no relatives to display.')
  end

end