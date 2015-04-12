class InvitationsController < ApplicationController

  before_action     :require_signin
  before_action     :get_correct_user

  def new
  end

  def create
    invitation = Invitation.new(invitation_params)
    invitation.sender = @user
    if invitation.recipient_not_self? && invitation.recipient_not_member?
      if invitation.save
        redirect_to new_relationship_path, success: 'Your invitation was sent.'
      else
        redirect_to new_relationship_path, danger: 'There was a problem sending your invitation.  Please try again.'
      end
    else
      redirect_to new_relationship_path, info: 'This user is already a member.'
    end
  end

  private

    def get_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

    def invitation_params
      params.require(:invitation).permit(:recipient_email)
    end

end
