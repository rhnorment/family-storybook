module Invitable

  extend ActiveSupport::Concern

  included do
    has_many    :invitations
    belongs_to  :invitation
  end

  def create_relationship_from_invitation(token)
    invitation = Invitation.find_by_token(token)
    inviter = invitation.user
    inviter.invite(self)
    self.approve(inviter)
    invitation.delete
  end

end