class ErrorsController < ApplicationController

  layout    'errors'

  def not_found
    @message = 'Page not found.'
  end

  def unprocessable
    @message = 'Unprocessable entity.'
  end

  def server_error
    @message = 'Monkeys have invaded our servers.  Please try again momentarily.'
  end

end
