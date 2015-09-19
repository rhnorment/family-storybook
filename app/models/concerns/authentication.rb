module Authentication

  extend ActiveSupport::Concern

  included do
    has_secure_password
  end

  module ClassMethods
    def authenticate(email, password)
      user = User.find_by(email: email)

      return false if user.is_inactive?

      user && user.authenticate(password)
    end
  end

end