class Innorganization < Category
  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :items,    :as => :itemable,    :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :address,   :as => :addressable, :dependent => :destroy
  has_one :chief, :class_name => 'Item', :as => :itemable

  after_initialize :set_address_attributes

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :emails
  accepts_nested_attributes_for :phones

  delegate :attributes, :postcode, :region, :district, :locality, :street, :house, :building,
           :to => :address,
           :prefix => true,
           :allow_nil => true

  has_enums
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
#  kind           :string(255)
#  status         :text
#  sphere         :text
#  production     :text
#  image_url      :text
#

