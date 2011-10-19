# encoding: utf-8

class Subdivision < ActiveRecord::Base
  has_many :buildings, :as => :addressable
  has_one :phone,      :as => :phoneable

  validates :title, :presence => true, :format => { :with => /^[а-яё\s\-\(\)«"»]+$/i }

  accepts_nested_attributes_for :buildings

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

