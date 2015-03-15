class RelationshipsController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user

  def index
    @page_title = 'My family members'
    @relatives = @user.relatives.order(created_at: :desc).page params[:page]
  end

  def new
    @page_title = 'Invite new family members'
    @invitees = @user.invitees.where.not(id: @user.id).order(created_at: :desc).page params[:page]
  end

  def create
    invitee = User.find(params[:user_id])
    if @user.invite(invitee)
      redirect_to new_relationship_url, success: 'Your invitation has been sent!'
    else
      redirect_to new_relationship_url, danger: 'Your invitation could not be sent.  Please try again.'
    end
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
