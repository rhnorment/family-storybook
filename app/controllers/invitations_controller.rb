class InvitationsController < ApplicationController

  before_action     :require_signin
  before_action     :get_correct_user

  def new
  end

  def create
    invitation = @user.invitations.new(invitation_params)

    if invitation.already_invited?
      redirect_to new_relationship_url, warning: "You have already invited #{invitation.recipient_email}.  Please contact this person directly."

    elsif invitation.find_member == @user
      redirect_to new_relationship_url, warning: 'You cannot invite yourself.  Please try again.'

    elsif @user.relatives.include?(invitation.find_member)
      redirect_to relationships_url, info: "You are already relatives with #{invitation.find_member.name}."

    elsif invitation.find_member.present?
      session[:recipient_email] = invitation.recipient_email
      redirect_to new_relationship_url, info: "#{invitation.recipient_email} is already a member."

    else
      if invitation.save
        redirect_to new_relationship_url, success: 'Your invitation was sent.'
      else
        redirect_to new_relationship_url, danger: 'You entered an invalid email address.  Please try again.'
      end
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
