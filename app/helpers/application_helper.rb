module ApplicationHelper

  # properly display a page title:
  def page_title
    @page_title ? "FamilyShare | #{@page_title.capitalize}" : 'FamilyShare'
  end

  # define active path on top menu items:
  def is_active?(action)
    current_page?(action: action) ? 'active' : nil
  end



end
