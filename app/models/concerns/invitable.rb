module Invitable

  extend            ActiveSupport::Concern

  included do
    has_many        :invitations, dependent: :destroy
  end



end