module Invitable

  extend ActiveSupport::Concern

  included do
    has_many    :invitations
    belongs_to  :invitation
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

end