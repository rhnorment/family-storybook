class ActivitiesController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user

  def index
    @page_title = 'My activities'
    @activities = Activity.where(owner: @user).order(created_at: :desc).page params[:page]
  end

  private

    def set_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

end
