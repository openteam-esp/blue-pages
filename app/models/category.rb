# encoding: utf-8

class Category < ActiveRecord::Base
  has_and_belongs_to_many :admin_users

  validates :title, :presence => true, :format => {:with => /^[а-яё[:space:]–\-\(\)«"»,]+$/i}

  default_scope order('weight')

  before_create :set_position, :set_weight
  before_update :set_weight

  has_ancestry

  delegate :weight, :to => :parent, :prefix => true, :allow_nil => true

  searchable do
    boost :boost

    text  :title, :boost => 1.5
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
  alias :categories :children

  def boost
    1.1 - decrement / 10
  end

  def decrement
    @decrement ||= ("0." + weights.reverse[0..-2].join).to_f
  end

  protected
    def set_position
      self.position = siblings.last.try(:position).to_i + 1 unless self.position
    end

    def set_weight
      self.weight = weights.join('/')
    end

    def weights
      @weights ||=  begin
                      [parent_weight, sprintf('%02d', position)].keep_if(&:present?).join('/').split('/')
                    end
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
#  weight     :string(255)
#

