require 'rails_helper'

describe ErrorsController, type: :controller do

  context 'when page not found' do
    it 'renders the page not found template' do
      expect(get :not_found).to render_template('layouts/errors')
      expect(get :not_found).to render_template :not_found
    end
  end

  context 'when unprocessable entity' do
    it 'renders the unprocessable entity template' do
      expect(get :unprocessable).to render_template('layouts/errors')
      expect(get :unprocessable).to render_template :unprocessable
    end
  end

  context 'server error' do
    it 'renders the internal server error template' do
      expect(get :server_error).to render_template('layouts/errors')
      expect(get :server_error).to render_template :server_error
    end
  end

end