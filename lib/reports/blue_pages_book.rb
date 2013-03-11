# encoding: utf-8

require 'prawn'
require 'progress_bar'

class BluePagesBook < Prawn::Document
  attr_accessor :root, :title

  def initialize(options={})
    self.root = options.delete(:root) || Category.root.children.first
    self.title = options.delete(:title) || "Телефонный справочник"
    super(options.reverse_merge(:page_size => 'A4', :margin => [50,38,25,50]))
  end

  def first_title_page
    text 'Администрация Томской области', :align => :center, :size => 9
    move_down 200
    text title, :align => :center, :size => 16
    creation_date = I18n.l(Date.today, :format => :long)
    text creation_date, :align => :center, :size => 9, :valign => :bottom
  end

  def second_title_page
    start_new_page
    text root.title, :size => 18, :valign => :center, :align => :center
    outline.section root.title
  end

  def set_page_headers
    repeat(->(page){page > 2}) do
      bounding_box([0, 800], :width => bounds.right) do
        text root.title, :size => 8, :align => :right
        move_down 5
        stroke_horizontal_rule
      end
    end
  end

  def categories
    @categories ||= root.subtree
  end

  def bar
    @bar ||= ProgressBar.new(categories.count)
  end

  def render_categories
    categories.each do |child|
      depth = child.depth - root.depth

      if (child.category? && child.children.any?) || child.subdivision?
        start_new_page if ((depth == 1) || (depth == 0 && root.subdivision?))


        depth -= 1 if root.category?

        unless child == root && root.category?
          render_subdivision child, depth
        end
      end
      bar.increment!
    end
  end

  def render_subdivision(subdivision, depth)
    font_size = 10
    font_size = 14 if depth == 0
    font_size = 12 if depth == 1

    move_down 16

    group do
      text subdivision.title, :size => font_size, :style => :bold
      move_down 4
      render_contacts subdivision
    end

    add_outline(subdivision)

    render_items subdivision if subdivision.subdivision?
  end

  def add_outline(category)
    outline.add_subsection_to(category.parent.title) do
      outline.section category.title, :destination => page_number
    end rescue nil
  end


  def render_items(object)
    object.items.each do |item|
      group do
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
      end
    end
  end

  def render_contacts(object, font_size = 10)
    if object.is_a?(Subdivision) || object.is_a?(Item)
      group do
        text object.emails.map(&:to_s).join(', '), :size => font_size-1, :indent_paragraphs => 10, :leading => 2
        text Phone.present_as_str(object.phones), :size => font_size-1, :indent_paragraphs => 10, :leading => 2
        text object.url.to_s, :url => object.url,  :size => font_size-1, :indent_paragraphs => 10, :leading => 2 if object.is_a? Subdivision
        text object.address.to_s, :size => font_size-1, :indent_paragraphs => 10, :leading => 2 if object.address.present?
      end
    end
  end

  def generate_pdf
    if RUBY_PLATFORM =~ /freebsd/
      font_families.update(
        "Verdana" => {
          :bold   => "/usr/local/lib/X11/fonts/webfonts/verdanab.ttf",
          :italic => "/usr/local/lib/X11/fonts/webfonts/verdanai.ttf",
          :normal => "/usr/local/lib/X11/fonts/webfonts/verdana.ttf" })
    else
      font_families.update(
        "Verdana" => {
          :bold   => "/usr/share/fonts/truetype/msttcorefonts/Verdana_Bold.ttf",
          :italic => "/usr/share/fonts/truetype/msttcorefonts/Verdana_Italic.ttf",
          :normal => "/usr/share/fonts/truetype/msttcorefonts/Verdana.ttf" })
    end
    font "Verdana", :size => 10

    first_title_page
    second_title_page

    render_categories

    set_page_headers

    render_file pdf_path
  end

  def pdf_path
    "#{Rails.root.join('..', 'shared', 'pdf', root.slug)}.pdf"
  end
end
