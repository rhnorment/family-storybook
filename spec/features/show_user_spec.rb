require 'rails_helper'

describe 'Viewing a user profile page', type: :feature do

  let(:user)        { create(:user) }
  let(:user_2)      { create(:user, name: 'User Two', email: 'user_2@example.com') }
  let(:user_3)      { create(:user, name: 'User Three', email: 'user_3@example.com') }

  before { sign_in(user) }

  describe 'nav items and user details' do
    before { visit user_url(user) }

    it 'shows the primary user nav elements' do
      expect(page).to have_link('Start a new storybook')
      expect(page).to have_link('Write a new story')
      expect(page).to have_link('Invite a new family member')
      expect(page).to have_link('Edit')
    end

    it 'shows the user details' do
      expect(page).to have_text(user.name)
      expect(page).to have_text('Storybooks')
      expect(page).to have_text('Stories')
      expect(page).to have_text('Family')
      expect(page).to have_text('Activity')
    end
  end

  describe 'listing user storybooks' do
    before do
      @storybook_1 = create(:storybook, user: user)
      @storybook_2 = create(:storybook, user: user)
      @storybook_3 = create(:storybook, user: user_2)

      visit user_url(user)
    end

    it 'lists ONLY the user storybooks in the storybooks tab' do
      within('#user-storybooks') do
        expect(page).to have_text(@storybook_1.title)
        expect(page).to have_text(@storybook_2.title)
        expect(page).to have_text('Not published')
        expect(page).to have_text('Started')
      end
    end

    it 'does not list storybooks not owned storybooks' do
      expect(page).to_not have_text(@storybook_3.title)
    end
  end

  describe 'listing user stories' do
    before do
      @story_1 = create(:story, user: user)
      @story_2 = create(:story, user: user)
      @story_3 = create(:story, user: user_2)

      visit user_url(user)
    end

    it 'lists ONLY the user stories in the stories tab' do
      within('#user-stories') do
        expect(page).to have_text(@story_1.title)
        expect(page).to have_text(@story_2.title)
        expect(page).to have_text('Inclusions')
        expect(page).to have_text('Written')
      end
    end

    it 'does not list stories not owned by the user' do
      expect(page).to_not have_text(@story_3.title)
    end
  end

  describe 'listing user relatives' do
    before do
      Relationship.create!(user_id: user.id, relative_id: user_2.id, pending: false)
      visit user_url(user)
    end

    it 'lists ONLY the most recent family members in the relatives tab' do
      within('#user-relatives') do
        expect(page).to have_text('User Two')
      end
    end

    it 'does not list non-relatives' do
      expect(page).to_not have_text('User Three')
    end
  end

  describe 'listing activities' do
     before do
       @storybook_1 = create(:storybook, user: user)
       @storybook_2 = create(:storybook, user: user)
       @storybook_3 = create(:storybook, user: user_2)
       @story_1 = create(:story, user: user)
       @story_2 = create(:story, user: user)
       @story_3 = create(:story, user: user_2)
       visit user_url(user)
     end

    it 'lists ONLY the user activities in the activity tab' do
      within('#user-activities') do
        expect(page).to have_text(@storybook_1.title)
        expect(page).to have_text(@storybook_2.title)
        expect(page).to have_text(@story_1.title)
        expect(page).to have_text(@story_2.title)
      end
    end

    it 'does not list activities not ownsed by the user' do
      expect(page).to_not have_text(@storybook_3.title)
      expect(page).to_not have_text(@story_3.title)
    end
  end

end