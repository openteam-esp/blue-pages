# == Schema Information
#
# Table name: emails
#
#  address        :string(255)
#  created_at     :datetime         not null
#  emailable_id   :integer
#  emailable_type :string(255)
#  id             :integer          not null, primary key
#  updated_at     :datetime         not null
#

class Email < ActiveRecord::Base
  belongs_to :emailable, :polymorphic => true

  validates :address, :presence => true, :email => true

  after_create  :send_messages_on_create
  after_update  :send_messages_on_update
  after_destroy :send_messages_on_destroy

  def to_s
    address
  end

  private
    delegate :send_messages_on_create, :send_messages_on_update, :send_messages_on_destroy, :to => :emailable
end
