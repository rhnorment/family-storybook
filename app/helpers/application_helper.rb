module ApplicationHelper

  # properly display a page title:
  def page_title
    @page_title ? "FamilyShare | #{@page_title}" : 'FamilyShare'
  end



end
