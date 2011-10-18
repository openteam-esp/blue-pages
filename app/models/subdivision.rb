# encoding: utf-8

class Subdivision < ActiveRecord::Base
  validates :title, :presence => true, :format => { :with => /^[а-яё\s\-\(\)«"»]+$/i }

  has_ancestry
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
#

