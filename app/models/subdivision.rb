# encoding: utf-8

class Subdivision < ActiveRecord::Base
  has_one :building,  :as => :addressable
  has_many :phones,   :as => :phoneable

  validates :title, :presence => true, :format => { :with => /^[а-яё\s\-\(\)«"»]+$/i }

  accepts_nested_attributes_for :building
  accepts_nested_attributes_for :phones,
                                :reject_if => ->(attr) { attr[:code].blank? && attr[:number].blank? && attr[:kind].blank? },
                                :allow_destroy => true

  default_scope order('position')

  has_ancestry

  searchable do
    text :abbr_and_title do
      "#{abbr} #{title}"
    end
  end

  def title_with_abbr
    res = title
    res << " (#{abbr})" if abbr.present?
    res
  end

  def display_name
    title
  end
end

# == Schema Information
#
# Table name: subdivisions
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#  position   :integer
#

