class RelationshipsController < ApplicationController

  before_action       :require_signin
  before_action       :set_correct_user

  def index
    @page_title = 'My family members'
    @relatives = @user.relatives.order(created_at: :desc).page params[:page]
  end

  def new
    @page_title = 'Add family members'
    @recipient = User.find_by_email(session[:recipient_email])  # used to send invitation email.
    @invitees = @user.invitees.where.not(id: @user.id).order(created_at: :desc).limit(5)
    session[:recipient_email] = nil
  end

  def create
    invitee = User.find(params[:user_id])

    if @user.invite(invitee)
      redirect_to new_relationship_url, success: 'Your invitation was sent.'
    else
      redirect_to new_relationship_url, danger: 'There was a problem sending your invitation.  Please try again.'
    end
  end

  def pending
    @page_title = 'Pending invitations'
    @pending_invited = @user.pending_invited
    @pending_invited_by = @user.pending_invited_by
  end

  def update
    inviter = User.find(params[:id])

    if @user.approve(inviter)
      redirect_to pending_relationships_url, success: "#{inviter.name} is now a relative!"
    else
      redirect_to pending_relationships_url, danger: 'There was a problem confirming your relationship.  Please try again.'
    end

  end

  def destroy
    user = User.find(params[:id])

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
