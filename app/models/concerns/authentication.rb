module Authentication

  extend ActiveSupport::Concern

  included do
    has_secure_password
  end

  module ClassMethods
    def User.authenticate(email, password)
      user = User.find_by(email: email)

      user && user.authenticate(password)
    end
  end

end