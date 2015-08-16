require 'rails_helper'

describe ErrorsController, type: :controller do  #400, 422, 500 response codes

  describe 'GET :not_found' do
    before { get :not_found }

    it { should route(:get, '/404').to(action: :not_found) }
    it { should respond_with(:success) }
    it { should render_with_layout(:errors) }
    it { should render_template(:not_found) }
    it { should_not set_flash }
  end

  describe 'GET :unprocessable' do
    before { get :unprocessable }

    it { should route(:get, '/422').to(action: :unprocessable) }
    it { should respond_with(:success) }
    it { should render_with_layout(:errors) }
    it { should render_template(:unprocessable) }
    it { should_not set_flash }
  end

  describe 'GET :server_error' do
    before { get :server_error }

    it { should route(:get, '/500').to(action: :server_error) }
    it { should respond_with(:success) }
    it { should render_with_layout(:errors) }
    it { should render_template(:server_error) }
    it { should_not set_flash }
  end

end