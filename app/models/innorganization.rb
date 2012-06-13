class Innorganization < Category
  has_one :address, :as => :addressable, :dependent => :destroy
  has_many :emails,   :as => :emailable,   :dependent => :destroy
  #has_many :items,                         :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  after_initialize :set_address_attributes
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :emails
  accepts_nested_attributes_for :phones
end
