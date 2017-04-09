module StaticPagesHelper

  def full_title(title = '')
    base_title = 'Rails Tutorial Sample App'
    if title.empty?
      full_title = base_title
    else
      full_title = title + ' | ' + base_title
    end
    full_title
  end
end
