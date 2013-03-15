# == Schema Information
#
# Table name: permissions
#
#  context_id   :integer
#  context_type :string(255)
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  role         :string(255)
#  updated_at   :datetime         not null
#  user_id      :integer
#

class Permission < ActiveRecord::Base
  attr_accessible :role, :context_id

  belongs_to :context, :polymorphic => true

  validates_presence_of :context

  sso_auth_permission roles: [:manager, :operator, :editor]

  extend Enumerize
  enumerize :role, in: [:manager, :operator, :editor]

  before_validation :set_context, :on => :create

  private

  def set_context
    self.context = Category.find(context_id)
  end
end
