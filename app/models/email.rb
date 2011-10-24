class Email < ActiveRecord::Base

  belongs_to :emailable, :polymorphic => true

  validates :address, :presence => true, :email => true

  def to_s
    address
  end

end

# == Schema Information
#
# Table name: emails
#
#  id             :integer         not null, primary key
#  address        :string(255)
#  emailable_id   :integer
#  emailable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

