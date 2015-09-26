require 'rails_helper'

describe StaticController, type: :controller do

  describe 'GET :home' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :home }

      it { should route(:get, '/').to(action: :home) }
      it { should respond_with(:success) }
      it { should render_with_layout(:static) }
      it { should render_template(:home) }
      it { should_not set_flash }
    end

    context 'when signed in' do
      before do
        session_for_user
        get :home
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'GET :how' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :how }

      it { should route(:get, '/how_it_works').to(action: :how) }
      it { should respond_with(:success) }
      it { should render_with_layout(:static) }
      it { should render_template(:how) }
      it { should_not set_flash }
    end

    context 'when signed in' do
      before do
        session_for_user
        get :how
      end

      it_behaves_like 'signed in as the current user'
    end
  end

  describe 'GET :showcase' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :showcase }

      it { should route(:get, '/showcase').to(action: :showcase) }
      it { should respond_with(:success) }
      it { should render_with_layout(:static) }
      it { should render_template(:showcase) }
      it { should_not set_flash }
    end

    context 'when signed in' do
      before do
        session_for_user
        get :showcase
      end

      it_behaves_like 'signed in as the current user'
    end
  end

end