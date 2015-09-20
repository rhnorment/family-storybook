class SessionsController < ApplicationController

  layout 'session'
  before_action     :walled_garden, only: [:new, :create]

  def new
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      if user.is_active?
        sign_in(user)

        flash[:success] = "Welcome back, #{user.name}!"

        redirect_to session[:intended_url] || storybooks_url

        session[:intended_url] = nil
      else
        flash.now[:danger] = 'Your account is currently inactive.'

        render :new
     end
    else
      flash.now[:danger] = 'Invalid email/password combination.'

      render :new
    end
  end

  def destroy
    sign_out_user

    redirect_to signin_url, info: 'You are now signed out.'
  end

end
