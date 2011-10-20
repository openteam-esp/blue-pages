class Item < ActiveRecord::Base
  belongs_to :subdivision
  has_one :person
  validates_presence_of :title

  accepts_nested_attributes_for :person, :reject_if => :all_blank

  def display_name
    title
  end
end

# == Schema Information
#
# Table name: items
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  subdivision_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

