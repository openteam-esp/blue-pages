module ApplicationHelper

  def render_address(resource)
    return resource.address if resource.parent.is_a?(Category)
    parent_address = resource.parent.address
  end

  def title
    action_title
  end

  def pluralized_model(controller_name = params[:controller])
    "pluralize.#{controller_name.to_s.singularize}"
  end

  def action_title(options={})
    controller_name = options[:controller] || params[:controller]
    action = options[:action] || params[:action]
    action_conf = case action
      when 'show'
        return resource
      when 'create'
        { :action => 'new', :count => 1 }
      when 'update'
        { :action => 'edit', :count => 1 }
      when 'index'
        { :action => action, :count => 10 }
      else
        { :action => action, :count => 2 }
      end
    "#{I18n.t("actions.#{action_conf[:action]}")} #{I18n.t(pluralized_model(controller_name), :count => action_conf[:count])}"
  end

  def expanded_ancestors(ancestors, options={})
    result = ""
    if ancestors.empty?
      obj = resource.is_a?(Item) ? resource.itemable : resource
      obj.children.each do |child|
        li_options = { :id => child.id }
        li_options.merge!(:class => 'hasChildren') if child.has_children?
        result += content_tag :li, li_options do
          res = ""
          res += content_tag(:span, link_to(child.title, [:manage, child]))
          res += content_tag(:ul, placeholder) if child.has_children?
          raw(res)
        end
      end
      return raw(result)
    end
    node = ancestors.shift
    siblings = options[:show_siblings] ? node.siblings : [node]
    siblings.each do |sibling|
      li_options = { :id => sibling.id }
      li_options.merge!(:class => 'hasChildren') if sibling.has_children?
      li_options[:class] += " open" if node == sibling && sibling.has_children?
      result += content_tag :li, li_options do
        res = ""
        res += content_tag(:span, link_to(sibling.title, [:manage, sibling]))
        res += content_tag :ul do
          node == sibling ? expanded_ancestors(ancestors, :show_siblings => true) : placeholder
        end if sibling.has_children?
        raw(res)
      end
    end
    raw(result)
  end

  def placeholder
    content_tag(:li, content_tag(:span, raw('&nbsp;'), :class => 'placeholder'))
  end

  def image_for(picture, options)
    original_width, original_height = picture[/\d+-\d+/].split('-')
    width = options.delete(:width)
    height = width.to_i * original_height.to_i / original_width.to_i
    image_tag picture.gsub(/\d+-\d+/, "#{width}-#{height}"), :width => width, :height => height
  end

end
