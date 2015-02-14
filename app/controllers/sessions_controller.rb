class SessionsController < ApplicationController

  layout 'session'

  def new
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name}!"
      redirect_to session[:intended_url] || user
      session[:intended_url] = nil
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to signin_url, info: 'You are now signed out.'
  end

end
