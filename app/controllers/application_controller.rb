class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types(:success, :info, :warning, :danger)

  private

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: 'Please sign in.'
    end
  end

  def current_user?(user)
    current_user == user
  end
  helper_method   :current_user?

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def walled_garden
    redirect_back_or(current_user) if current_user
  end

end
