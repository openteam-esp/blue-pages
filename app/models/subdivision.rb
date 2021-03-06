# encoding: utf-8
require 'base64'

class Subdivision < Category

  attr_accessible :dossier, :image, :url, :mode, :appointments
  attr_accessible :address_attributes, :emails_attributes, :phones_attributes

  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :items,    :as => :itemable,    :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :chief, :class_name => 'Item', :as => :itemable
  has_one :address,  :as => :addressable, :dependent => :destroy

  validates :address, :parent, :presence => true
  validates :abbr,    :allow_blank => true, :format => { :with => VALID_TITLE }
  validate :valid_url?, :allow_blank => true, :if => :url?

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

    def valid_url?
      begin
        uri = URI.parse(URI.encode(url))
      rescue URI::InvalidURIError
        errors.add(:url, 'имеет неверное значение')
      end
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
#  appointments       :text
#
