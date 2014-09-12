class UserSearch < Search
  attr_accessible :term

  column :order_by, :string
  column :term, :text
  column :permissions_count_gt, :integer
end
