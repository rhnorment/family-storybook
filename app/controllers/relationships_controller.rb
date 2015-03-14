class RelationshipsController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user

  def index
    @page_title = 'My family members'
    @relatives = @user.relatives.order(created_at: :desc).page params[:page]
  end

  def new
    @page_title = 'Add new family members'
    @users = User.where.not(id: @user.id).order(created_at: :desc).page params[:page]
  end

  def create

  end

  def edit
  end

  def update
  end

  def destroy
    user = User.find_by_id(params[:id])
    if @user.remove_relationship(user)
      redirect_to relationships_url, warning: 'Your family member was removed.'
    else
      redirect_to relationships_url, danger: 'There was a problem removing your family member.  Please try again.'
    end
  end

  private

    def set_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

end
