# encoding: utf-8

require 'base64'

class Subdivision < Category
  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :items,                         :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :chief, :class_name => 'Item'
  has_one :address,  :as => :addressable, :dependent => :destroy

  validates :address, :parent, :presence => true

  validates :abbr, :allow_blank => true,
                   :format => { :with => /^[а-яё[:space:]–\-\(\)«"»,]+$/i }

  validates :url,  :allow_blank => true,
                   :format => { :with => %r{^
                                  (http|https)://                                 # scheme
                                  (
                                   [a-z0-9]+([-.][a-z0-9]+)*\.[a-z]{2,5} |        # latin domain
                                   [а-яё0-9]+([-.][а-яё0-9]+)*\.рф                # cyrillic domain
                                  )
                                  (/[[:alnum:] -]+)*                              # path
                                  /?
                                  (\?.*)?                                         # query params
                                $}ix }

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


  normalize_attribute :url do | value |
    value = "http://#{value}" unless value.blank? || value.starts_with?('http')
    value
  end

  searchable do
    boost :boost
    text :term
  end

  def dossier
    c = Curl::Easy.perform("#{remote_url}&target=r1_#{str_to_hash(info_path.gsub(/^\//,''))}")
    JSON.parse(c.body_str)['content']
  end

  private

    def term
     "#{abbr} #{title} #{address} #{url} #{phones.join(' ')} #{emails.join(' ')}"
    end

    def str_to_hash(str)
      Base64.urlsafe_encode64(str).strip.tr('=', '')
    end

    def remote_url
      "#{Settings['storage.url']}/api/el_finder/v2?format=json&cmd=get"
    end

    def set_address_attributes
      if self.new_record?
        self.build_address(parent.address_attributes.symbolize_keys.merge(:id => nil, :office => nil)) and return  if self.parent && self.parent.is_a?(Subdivision) && !self.address
        self.build_address unless self.address
      end
    end

end

# == Schema Information
#
# Table name: categories
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  title          :text
#  abbr           :string(255)
#  url            :text
#  info_path      :text
#  position       :integer
#  weight         :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

