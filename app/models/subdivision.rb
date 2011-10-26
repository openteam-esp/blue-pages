# encoding: utf-8

class Subdivision < ActiveRecord::Base
  has_and_belongs_to_many :admin_users

  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :items,                         :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :address,  :as => :addressable, :dependent => :destroy

  validates :title, :presence => true, :format => {:with => /^[а-яё[:space:]–\-\(\)«"»,]+$/i}

  validates_format_of :url,
                      :allow_blank => true,
                      :with => %r{^
                                  (http|https)://                                 # scheme
                                  (
                                   [a-z0-9]+([-.][a-z0-9]+)*\.[a-z]{2,5} |        # latin domain
                                   [а-яё0-9]+([-.][а-яё0-9]+)*\.рф                # cyrillic domain
                                  )
                                  (/[[:alnum:] -]+)*                              # path
                                  /?
                                  (\?.*)?                                         # query params
                                $}ix

  accepts_nested_attributes_for :address,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) }

  accepts_nested_attributes_for :emails,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  accepts_nested_attributes_for :phones,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  default_scope order('position')

  delegate :attributes, :postcode, :region, :district, :locality, :street, :house, :building,
           :to => :address,
           :prefix => true,
           :allow_nil => true

  has_ancestry

  alias :subdivisions :children

  normalize_attribute :url do | value |
    value = "http://#{value}" unless value.blank? || value.starts_with?('http')
    value
  end

  searchable do
    text :abbr, :boost => 1.5
    text :title, :boost => 1.5
    text :address
    text :url
    text :phones do phones.join(' ') end
    text :emails do emails.join(' ') end
  end

  def title_with_abbr
    res = title
    res << " (#{abbr})" if abbr.present?
    res
  end

  def display_name
    title
  end

  alias :to_s :display_name
end

# == Schema Information
#
# Table name: subdivisions
#
#  id         :integer         not null, primary key
#  title      :text
#  abbr       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#  position   :integer
#  url        :text
#

