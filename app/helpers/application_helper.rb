module ApplicationHelper

  #------------------------------------------------------------------
  # ページごとに完全なタイトルを返す
  # Viewでの使い方 : <%= full_title("HOME") %>
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'

    #  falseまたはnil
    if !page_title    || page_title.empty?
      base_title
    else
      base_title = page_title + " | " + base_title
    end
  end
end
