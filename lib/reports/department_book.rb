# encoding: utf-8
require 'prawn'

class DepartmentBook < BluePagesBook

  def title
    'Телефонный справочник'
  end

  def root_categories
    category.subtree.each do |child|
      depth = child.depth - category.depth
      if child.items.any?
        start_new_page if depth <= 1
        render_subdivision child, depth
      end
    end
  end

  def render_subdivision(subdivision, depth)

    font_size = 10
    font_size = 14 if depth == 0
    font_size = 12 if depth == 1

    text subdivision.title, :size => font_size, :style => :bold
    move_down 15

    outline.add_subsection_to(subdivision.parent.title) do
      outline.section subdivision.title, :destination => page_number
    end rescue nil

    render_contacts subdivision
    render_items subdivision
  end

end
