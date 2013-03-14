class Permission < ActiveRecord::Base
  attr_accessible :context_string, :role, :context_id
  attr_accessor :context_string

  validates_presence_of :context_string

  sso_auth_permission roles: [:manager, :operator, :editor]

  extend Enumerize
  enumerize :role, in: [:manager, :operator, :editor]

  before_create :set_context_type_and_id

  private

  def set_context_type_and_id
    context_type, context_id = context_string.split('_')

    self.context_type = context_type.classify
    self.context_id = context_id
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  role         :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

