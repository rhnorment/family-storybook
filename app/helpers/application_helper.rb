module ApplicationHelper

  # properly display a page title:
  def page_title
    @page_title ? "FamilyBook | #{@page_title.capitalize}" : 'FamilyBook'
  end

  # return true if current controller
  def is_controller?(controller)
    current_page?(controller: controller)
  end

  # return true if current action:
  def is_action?(action)
    current_page?(action: action)
  end

  # returns the active class or nil:
  def is_active?(controller)
    current_page?(controller: controller) ? 'active' : nil
  end

  # render the sub navigation only if it exists
  def is_present?
    lookup_context.template_exists?('sub_nav', controller_name, true)
  end

end
