module ActiveAdmin::ViewHelpers
  def render_tree(categories)
    categories.map do |category, child_categories|
      content_tag(:div, link_to(category.title, admin_category_path(category)), :class => 'category') + (child_categories.empty? ? '' : content_tag(:div, render_tree(child_categories), :class => 'nested_categories'))
    end.join.html_safe
  end
end
