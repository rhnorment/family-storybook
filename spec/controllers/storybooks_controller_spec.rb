require 'rails_helper'

describe StorybooksController, type: :controller do
  describe 'GET :index' do
    context 'user not signed in' do
      before { get :index }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do
      let(:user)            { create(:user) }
      let(:wrong_user)      { create(:user, :wrong_user) }
      let(:storybook_1)     { create(:storybook, user: user) }
      let(:storybook_2)     { create(:storybook, user: user) }
      let(:wrong_storybook) { create(:storybook, user: wrong_user) }

      before { session_for_user }

      describe 'requesting HTML format' do
        before { get :index }

        it { is_expected.to route(:get, '/storybooks').to(action: :index) }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_with_layout(:application) }
        it { is_expected.to render_template(:index) }
        it { is_expected.to_not set_flash }

        it 'should set the page title' do
          expect(assigns(:page_title)).to eql('My storybooks')
        end

        it 'should correctly assign the storybook collection' do
          expect(assigns(:storybooks)).to include(storybook_1, storybook_2)
        end

        it 'should correctly assign the storybook collection' do
          expect(assigns(:storybooks)).to_not include(wrong_storybook)
        end
      end

      describe 'requesting JSON format' do
        before { get(:index, format: :json) }

        it { is_expected.to route(:get, '/storybooks.json').to(action: :index, format: :json) }
        it { is_expected.to respond_with(:success) }

        it 'should retrieve JSON content type' do
          expect(response.header['Content-Type']).to include('application/json')
        end

        it 'includes titles' do
          storybooks = json(response.body)
          titles = storybooks.map { |sb| sb[:title] }
          expect(titles).to include('Storybook Title', 'Storybook Two Title')
        end
      end
    end
  end

  describe 'GET => :show' do
    let(:user)      { create(:user) }
    let(:storybook) { create(:storybook, user: user) }

    context 'user not signed in' do
      before { get(:show, id: storybook.id) }

      it_behaves_like 'user not signed in'
    end

    context 'when signed in as current user' do
      before { session_for_user }

      describe 'requesting HTML format' do
        before { get(:show, id: storybook.id) }

        it { is_expected.to route(:get, '/storybooks/1').to(action: :show, id: '1') }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_with_layout(:application) }
        it { is_expected.to render_template(:show) }
        it { is_expected.to_not set_flash }

        it 'assigns the page title' do
          expect(assigns(:page_title)).to eql("Showing: Storybook-#{storybook.id} Title")
        end
      end

      context 'requesting JSON format'
    end

    context 'when signed in as a different user' do
      let(:user)            { create(:user) }
      let(:wrong_user)      { create(:user, :wrong_user) }
      let(:storybook)       { create(:storybook, user: user) }

      before do
        session_for_wrong_user
        get(:show, id: storybook.id)
      end

      it_behaves_like 'signed in as a different user'
    end
  end

  describe 'GET => :new' do
    context 'user not signed in' do
      before { get(:new) }

      it_behaves_like 'user not signed in'
    end

    context 'signed in as the current user' do

    end




  end

end