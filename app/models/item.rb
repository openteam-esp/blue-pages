class Item < ActiveRecord::Base
  belongs_to :subdivision
  has_one :person
  validates_presence_of :title

  accepts_nested_attributes_for :person, :reject_if => :all_blank
end
