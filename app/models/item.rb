class Item < ActiveRecord::Base
  belongs_to :subdivision

  has_one :building, :as => :addressable
  has_one :person

  validates_presence_of :title

  after_initialize :set_building_attributes

  accepts_nested_attributes_for :building
  accepts_nested_attributes_for :person, :reject_if => :all_blank

  delegate :postcode, :region, :district, :locality, :street, :house, :building, :to => :building, :prefix => true, :allow_nil => true

  def display_name
    title
  end

  private
    def set_building_attributes
      build_building subdivision.building_attributes if subdivision && !building
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
#  office         :string(255)
#

