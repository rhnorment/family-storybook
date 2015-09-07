module Invitation

  extend ActiveSupport::Concern

  included do
    has_many    :invitations,   dependent: :destroy
  end

  def create_relationship_from_invitation(token)
    invitation = Invitation.find_by_token(token)
    Relationship.create(user_id: self.id, relative_id: invitation.user.id, pending: false)
    invitation.delete
  end

end
# TODO:  implement create relationship from invitation methods.

# TODO:  market pending=false instead of deleting an executed invitation.