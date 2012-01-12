class Permission < ActiveRecord::Base
  belongs_to :context, :class_name => 'Category'
  belongs_to :user
  has_enum :role

  validates_presence_of :context, :role
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer         not null, primary key
#  context_id   :integer
#  context_type :string(255)
#  user_id      :integer
#  role         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

