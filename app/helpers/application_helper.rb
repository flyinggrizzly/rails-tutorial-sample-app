module ApplicationHelper
  def full_title(title = '')
    base_title = 'Rails Tutorial Sample App'
    if title.empty?
      full_title = base_title
    else
      full_title = title.capitalize + ' | ' + base_title
    end
    full_title
  end

  def page_title(title = 'Sample App')
    title
  end
end
