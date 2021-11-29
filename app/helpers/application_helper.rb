module ApplicationHelper
  def full_title page_title = ""
<<<<<<< HEAD
    base_title = I18n.t "rails"
=======
    base_title = I18n.t "base_title"
>>>>>>> 36c1da397c04b220a578e90a95cabfceb05fea8b
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
