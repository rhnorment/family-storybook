class PasswordResetsController < ApplicationController

  layout 'session'
  before_action       :walled_garden
  before_action       :get_user,            only: [:edit, :update]
  before_action       :valid_user,          only: [:edit, :update]
  before_action       :check_expiration,    only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email

      flash.now[:info] = 'An email has been sent with password reset instructions.  You may close this window.'

      render :new
    else
      flash.now[:danger] = 'Email address not found.  Please try again.'

      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      flash.now[:danger] = 'Password cannot be blank.'

      render :edit
    elsif @user.update_attributes(user_params)
      session[:user_id] = @user.id

      redirect_to @user, success: 'Your password has been reset.'
    else
      flash.now[:warning] = 'We were unable to reset your password.  Please contact customer support.'

      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      redirect_to root_url unless @user
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired.  Please try again or contact customer support.'
        redirect_to new_password_reset_url
      end
    end

end
