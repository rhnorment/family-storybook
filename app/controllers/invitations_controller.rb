class InvitationsController < ApplicationController

  before_action     :require_signin


  def new
    @invitation = Invitation.new

  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy


  end

end
