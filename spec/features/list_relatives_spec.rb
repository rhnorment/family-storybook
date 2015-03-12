require 'spec_helper'

describe 'listing relatives' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'Example User 2'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'Example User 3'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com'))
    sign_in(@user1)
  end

  it 'should list all the approved relationships and allow the user to remove the relationship' do
    Relationship.delete_all
    expect(@user1.invite(@user2)).to be_true    # john invites jane
    expect(@user3.invite(@user1)).to be_true    # peter invites john
    expect(@user1.invite(@user4)).to be_true    # john invites james
    expect(@user4.approve(@user1)).to be_true   # james approves john
    expect(@user5.invite(@user1)).to be_true    # mary invites john
    expect(@user1.approve(@user5)).to be_true   # john approves mary

    visit relationships_url

    expect(page).to have_text(@user4.name)
    expect(page).to have_text(@user5.name)
    expect(page).to have_text('Relative since')
    expect(page).to have_link('Remove relative')
  end

  it 'should not list all the pending relationships invited by the user' do
    Relationship.delete_all
    expect(@user1.invite(@user2)).to be_true    # john invites jane
    expect(@user3.invite(@user1)).to be_true    # peter invites john
    expect(@user1.invite(@user4)).to be_true    # john invites james
    expect(@user4.approve(@user1)).to be_true   # james approves john
    expect(@user5.invite(@user1)).to be_true    # mary invites john
    expect(@user1.approve(@user5)).to be_true   # john approves mary

    visit relationships_url

    expect(page).to_not have_text(@user2.name)
  end

  it 'should not list all the pending relationships that invited the user' do
    Relationship.delete_all
    expect(@user1.invite(@user2)).to be_true    # john invites jane
    expect(@user3.invite(@user1)).to be_true    # peter invites john
    expect(@user1.invite(@user4)).to be_true    # john invites james
    expect(@user4.approve(@user1)).to be_true   # james approves john
    expect(@user5.invite(@user1)).to be_true    # mary invites john
    expect(@user1.approve(@user5)).to be_true   # john approves mary

    visit relationships_url

    expect(page).to_not have_text(@user3.name)
  end

  it 'should render the nothing_to_render_alert partial if there are no relatives' do
    visit relationships_url

    expect(page).to have_text('There are no relatives to display.')
  end

end