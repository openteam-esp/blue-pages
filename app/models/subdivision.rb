# encoding: utf-8
require 'base64'

class Subdivision < Category
  VALID_URL = %r{
                  \A
                      (http|https)://                                 # scheme
                      (
                        [a-z0-9]+([-\.][a-z0-9]+)*\.[a-z]{2,5} |      # latin domain
                        [а-яё0-9]+([-\.][а-яё0-9]+)*\.рф              # cyrillic domain
                      )
                      (/[[:alnum:] -]+)*                              # path
                      /?
                      (\?.*)?                                         # query params
                   \z
                }x

  attr_accessible :dossier, :image, :url, :mode
  attr_accessible :address_attributes, :emails_attributes, :phones_attributes

  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :items,    :as => :itemable,    :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :chief, :class_name => 'Item', :as => :itemable
  has_one :address,  :as => :addressable, :dependent => :destroy

  validates :address, :parent, :presence => true
  validates :abbr,    :allow_blank => true, :format => { :with => VALID_TITLE }
  validates :url,     :allow_blank => true, :format => { :with => VALID_URL }

  after_initialize :set_address_attributes

  accepts_nested_attributes_for :address

  accepts_nested_attributes_for :emails,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  accepts_nested_attributes_for :phones,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  delegate :attributes, :postcode, :region, :district, :locality, :street, :house, :building,
           :to => :address,
           :prefix => true,
           :allow_nil => true

  after_update :change_item_weights

  normalize_attribute :url do | value |
    value = "http://#{value}" unless value.blank? || value.starts_with?('http')
    value
  end

  searchable do
    boost :boost

    text  :abbr,    :boost => 1.5
    text  :title,   :boost => 1.5
    text  :address, :boost => 0.7
    text  :url,     :boost => 0.7
    text  :phones,  :boost => 0.7 do phones.join(' ') end
    text  :emails,  :boost => 0.7 do emails.join(' ') end

    text  :term,    :boost => 0.5
  end

  private
    def change_item_weights
      items.each do |item|
        item.send :set_weight
        item.save
      end
    end

    def term
     "#{abbr} #{title} #{address} #{url} #{phones.join(' ')} #{emails.join(' ')}"
    end
end

# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  type               :string(255)
#  title              :text
#  abbr               :string(255)
#  url                :text
#  info_path          :text
#  position           :integer
#  weight             :string(255)
#  ancestry           :string(255)
#  ancestry_depth     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  kind               :string(255)
#  status             :text
#  sphere             :text
#  production         :text
#  image_url          :text
#  slug               :string(255)
#  dossier            :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  mode               :text
#
