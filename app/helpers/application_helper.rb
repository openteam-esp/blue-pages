module ApplicationHelper

  def render_address(resource)
    return resource.address if resource.parent.is_a?(Category)
    parent_address = resource.parent.address
  end
end
