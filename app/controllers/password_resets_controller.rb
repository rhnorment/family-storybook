class PasswordResetsController < ApplicationController

  layout 'session'

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash.now[:info] = 'An email has been sent with password reset instructions.'
      render :new, layout: 'session'
    else
      flash.now[:danger] = 'Email address not found.  Please try again.'
      render :new, layout: 'session'
    end
  end

  def edit
  end

end
