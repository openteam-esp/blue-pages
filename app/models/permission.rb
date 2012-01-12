class Permission < ActiveRecord::Base
  belongs_to :context, :polymorphic => true
  belongs_to :user
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

