require 'rails_helper'

describe PasswordResetsController, type: :controller do

  context 'when requesting a password reset' do
    before do
      @user = User.create!(user_attributes)
    end

    it 'has access to new' do
      expect(get :new).to render_template :new
    end

    it 'creates a password reset if the credentials are valid' do
      expect {
        post :create, email: @user.email
        @user.create_reset_digest
      }.to change(ActionMailer::Base.deliveries, :count).by(+1)
    end

    it 'does not create a password reset if the credentials are invalid' do
      expect { post :create, email: 'notamember@example.com' }.to_not change(ActionMailer::Base.deliveries, :count)
    end
  end

  context 'when resetting a password' do
    before do
      @user = User.create!(user_attributes)
      post :create, email: @user.email
      @user.create_reset_digest
    end

    it 'has access to edit' do
      expect(get :edit, id: @user.reset_token, email: @user.email).to render_template :edit
    end

    it 'does not reset the password if the password field is blank' do
      expect { patch :update, id: @user.reset_token }.to_not change(@user, :password_digest)
    end

    it 'resets the password if the credentials are valid'

    it 'does not reset the password if the credentials are invalid'

  end

end

