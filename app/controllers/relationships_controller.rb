class RelationshipsController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user
  before_action     :set_relationship,  only: [:show, :edit, :update, :destroy]

  def index
    @page_title = 'My family members'
    @relationships = @user.relationships.order(created_at: :desc).page params[:page]
  end

  def show
  end

  def new
  end

  def create
    @relationship = @user.relationships.new(relative_id: params[:relative_id])
    if @relationship.save
      redirect_to @user, success: 'You successfully added your family member.'
    else
      redirect_to users_url, danger: 'There was a problem adding your family member.  Please try again.'
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @relationship.destroy
    redirect_to @user, warning: 'You have removed your relative from your family members.'
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
