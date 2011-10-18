# encoding: utf-8

class Subdivision < ActiveRecord::Base
  validates :title, :presence => true, :format => { :with => /^[а-яё\s\-\(\)«"»]+$/i }

  has_ancestry
end
