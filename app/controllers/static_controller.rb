class StaticController < ApplicationController

  before_action   :walled_garden

  layout  'static'

  def home
    @page_title = 'Home'
  end

  def how
    @page_title = 'How it works'
  end

  def showcase
    @page_title = 'Showcase'
  end

end
