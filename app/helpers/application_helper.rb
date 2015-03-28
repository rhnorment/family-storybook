module ApplicationHelper

  # properly display a page title:
  def page_title
    @page_title ? "FamilyBook | #{@page_title.capitalize}" : 'FamilyBook'
  end

  # render the sub navigation only if it exists
  def is_present?
    lookup_context.template_exists?('sub_nav', controller_name, true)
  end

end
