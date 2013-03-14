# == Schema Information
#
# Table name: searches
#
#  order_by             :string
#  permissions_count_gt :integer
#  term                 :text
#

class UserSearch < Search
  attr_accessible :term

  column :order_by, :string
  column :term, :text
  column :permissions_count_gt, :integer
end
