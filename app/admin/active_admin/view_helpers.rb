module ActiveAdmin::ViewHelpers
  def render_subdivisions_tree(subdivisions)
    subdivisions.map do |subdivision, child_subdivisions|
      content_tag(:div, link_to(subdivision.title, admin_subdivision_path(subdivision)), :class => 'subdivision') + (child_subdivisions.empty? ? '' : content_tag(:div, render_subdivisions_tree(child_subdivisions), :class => 'nested_subdivisions'))
    end.join.html_safe
  end
end
