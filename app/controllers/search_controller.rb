class SearchController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user

  def search
    @page_title = 'Search results'
    if params[:query].blank?
      @results = []
    else
      @results = PgSearch.multisearch(params[:query]).to_a
    end
  end

  private

    def set_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

end
