# encoding: utf-8

class BluePagesBook < Prawn::Document
  def title_page
    text 'Администрация Томской области', :align => :center, :size => 9
    move_down 200
    text 'Справочник телефонов органов государственной власти и органов местного самоуправления Томской области', :align => :center, :size => 16
    creation_date = I18n.l(Date.today, :format => :long)
    text creation_date, :align => :center, :size => 9, :valign => :bottom
    start_new_page
  end

  def root_categories
    category = Category.root.children.first
    text category.title, :size => 18, :valign => :center, :align => :center
    outline.section category.title
    start_new_page
    @pages_arr = []
    render_subdivision(category)
    pages_arr = @pages_arr

    repeat(lambda { |pg| pages_arr.include? pg}) do
      bounding_box([0, 800], :width => bounds.right) do
        text category.title, :size => 8, :align => :right
        move_down 5
        stroke_horizontal_rule
      end
    end
  end

  def render_subdivision(category)
    category.children.each do |subdivision|
      font_size = 10
      font_size = 14 if subdivision.depth == 2
      font_size = 12 if subdivision.depth == 3

      text subdivision.title, :size => font_size, :style => :bold
      move_down 15

      @pages_arr << page_number
      outline.add_subsection_to(subdivision.parent.title) do
        outline.section subdivision.title, :destination => page_number
      end

      render_contacts subdivision
      render_items subdivision
      render_subdivision subdivision
      start_new_page if subdivision.depth == 3
    end
  end

  def render_items(object)
    object.items.each do |item|
      move_down 8
      text item.title, :size => 8, :style => :bold, :leading => 2
      outline.add_subsection_to(object.title) do
        outline.section item.title, :destination => page_number
      end
      text item.full_name, :size => 8, :style => :italic, :indent_paragraphs => 10, :leading => 1 if item.full_name.present?
      outline.add_subsection_to(item.title) do
        outline.section item.full_name, :destination => page_number
      end if item.full_name.present?
      render_contacts(item, 8)
    end if object.is_a? Subdivision
  end

  def render_contacts(object, font_size = 10)
    if object.is_a?(Subdivision) || object.is_a?(Item)
      text object.emails.map(&:to_s).join(', '), :size => font_size-1, :indent_paragraphs => 10, :leading => 2
      text Phone.present_as_str(object.phones), :size => font_size-1, :indent_paragraphs => 10, :leading => 2
      text object.url.to_s, :url => object.url,  :size => font_size-1, :indent_paragraphs => 10, :leading => 2 if object.is_a? Subdivision
      text object.address.to_s, :size => font_size-1, :indent_paragraphs => 10, :leading => 2 if object.address.present?
    end
  end

  def to_pdf
    font_families.update(
      "Verdana" => {
      :bold => "/usr/share/fonts/truetype/msttcorefonts/Verdana_Bold.ttf",
      :italic => "/usr/share/fonts/truetype/msttcorefonts/Verdana_Italic.ttf",
      :normal  => "/usr/share/fonts/truetype/msttcorefonts/Verdana.ttf" })
    font "Verdana", :size => 10

    title_page
    root_categories
    render
  end
end
