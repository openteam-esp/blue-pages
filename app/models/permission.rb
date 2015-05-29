class Permission < ActiveRecord::Base
  attr_accessor :context_autocomplete

  attr_accessible :role, :context_id, :context_autocomplete

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

# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  role         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
