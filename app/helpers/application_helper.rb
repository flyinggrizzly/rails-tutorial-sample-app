module ApplicationHelper

  # provides page titles, defaulting to the base title if none is provided for the page
  def full_title(page_title = '')
    base_title = 'Rails Tutorial Sample App'
    if page_title.empty?
      base_title
    else
      page_title = "#{page_title} | #{base_title}"
    end
  end
end
