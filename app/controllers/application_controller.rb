class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  add_flash_types(:success, :info, :warning, :danger)

  rescue_from     ActiveRecord::RecordNotFound,   with: :record_not_found

  private

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out_user
      session[:user_id] = nil
    end

    def require_signin
      unless current_user
        session[:intended_url] = request.url
        redirect_to new_session_url, alert: 'Please sign in.'
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method   :current_user

    def current_user?(user)
      current_user == user
    end
    helper_method   :current_user?

    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end

    def record_not_found
      flash[:warning] = 'The item you are looking for is not available.'
      redirect_back_or(current_user) if current_user
    end

    def walled_garden
      redirect_back_or(current_user) if current_user
    end

end
