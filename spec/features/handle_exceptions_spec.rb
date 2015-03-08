require 'spec_helper'

describe 'Page not found exception handling' do

  context 'when user is not signed in' do

    it 'should present the page not found error page when visiting an unavailable page' do
      visit '/foo'

      expect(page).to have_text('Page not found.')
      expect(page).to have_link('OK')
    end

    it 'should return the user to the home page when the user clicks the ok link' do
      visit root_url

      visit '/foo'

      click_link 'OK'

      expect(current_path).to eq(root_path)
    end

  end

  context 'when user is signed in' do

    before do
      @user = User.create!(user_attributes)
      sign_in(@user)
    end

    it 'should present the page not found error page when visiting an unavailable page' do
      visit user_url(@user)
      visit '/foo'

      expect(page).to have_text('Page not found.')
      expect(page).to have_link('OK')
    end

    it 'should return the user to the home page when the user clicks the ok link' do
      visit user_url(@user)

      visit '/foo'

      click_link 'OK'

      expect(current_path).to eq(user_path(@user))
    end

  end

end

describe 'Record not found exception handling' do

  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'should flash an error message and redirect the user back to his profile page' do
    visit storybooks_url
    visit storybook_url(42)

    expect(current_path).to eq(user_path(@user))
    expect(page).to have_text('The item you are looking for is not available.')
  end

end