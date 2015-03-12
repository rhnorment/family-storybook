require 'spec_helper'

describe 'removing relatives' do

  before do
    @user1 = User.create!(user_attributes)
    @user2 = User.create!(user_attributes(email: 'user2@example.com', name: 'Example User 2'))
    @user3 = User.create!(user_attributes(email: 'user3@example.com', name: 'Example User 3'))
    @user4 = User.create!(user_attributes(email: 'user4@example.com'))
    @user5 = User.create!(user_attributes(email: 'user5@example.com'))
    sign_in(@user1)
  end

  it 'deletes the relationship records and removes the relative from the relatives list and redirects to the relatives page' do
    Relationship.delete_all
    expect(@user1.invite(@user2)).to be_true    # john invites jane
    expect(@user3.invite(@user1)).to be_true    # peter invites john
    expect(@user1.invite(@user4)).to be_true    # john invites james
    expect(@user4.approve(@user1)).to be_true   # james approves john

    visit relationships_url

    expect(page).to have_text(@user4.name)
    expect(page).to have_link('Remove relative')

    expect(@user1.relatives.size).to eq(1)

    click_link 'Remove relative'

    expect(@user1.relatives.size).to eq(0)

    expect(page).to have_text('Your family member was removed.')

    expect(current_path).to eq(relationships_path)
  end

end