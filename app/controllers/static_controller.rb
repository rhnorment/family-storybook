class StaticController < ApplicationController

  layout  'static', except: :home

  def home
    @page_title = 'Home'
  end

  def about
    @page_titla = 'About us'
  end

end
