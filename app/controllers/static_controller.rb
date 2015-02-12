class StaticController < ApplicationController

  layout  'static'

  def home
    @page_title = 'home'
    render layout: 'landing'
  end

end
