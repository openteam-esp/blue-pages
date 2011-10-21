module ActiveAdmin::ViewHelpers

  def building_address(object)
    result = object.significant_values[0..-2].uniq.join(", ")
    result += "/" + object.significant_values.pop unless object.significant_values.pop.blank?
    content_tag :p, result
  end

end
