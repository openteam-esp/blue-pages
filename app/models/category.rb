# encoding: utf-8

class Category < ActiveRecord::Base
  has_and_belongs_to_many :admin_users

  validates :title, :presence => true, :format => {:with => /^[а-яё[:space:]–\-\(\)«"»,]+$/i}

  default_scope order('position')

  before_create :set_position

  has_ancestry

  searchable do
    text :title, :boost => 1.5
  end

  def display_name
    title
  end

  def self.root
    Category.find_or_create_by_title('Телефонный справочник')
  end

  def subdivisions
    Subdivision.where(:ancestry => child_ancestry)
  end

  alias :to_s :display_name

  private
    def set_position
      self.position = siblings.last.try(:position).to_i + 1
    end

end

# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  title      :text
#  abbr       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#  position   :integer
#  url        :text
#  type       :string(255)
#

