class InvitationsController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user
  before_action     :set_invitation,      only: [:edit, :update]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new
  end

  def edit
  end

  def update
  end

  private

    def set_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

end
