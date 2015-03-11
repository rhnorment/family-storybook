class RelationshipsController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user
  before_action     :set_relationship,  only: [:show, :edit, :update, :destroy]

  def index
    @page_title = 'My family members'
    @relatives = @user.relatives.order(created_at: :desc).page params[:page]
  end

  def show
  end

  def new
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
      redirect_to relationships_url, warning: 'Your family member was removed. '
    else
      redirect_to relationships_url, danger: 'There was a problem removing your family member.  Please try again.'
    end
  end

  private

    def set_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

    def set_relationship
      @relationship = Relationship.find(params[:id])
      redirect_to @user unless @relationship.user == current_user
    end

end
