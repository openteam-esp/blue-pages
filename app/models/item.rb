class Item < ActiveRecord::Base
  belongs_to :subdivision

  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :address,   :as => :addressable, :dependent => :destroy
  has_one :person,                         :dependent => :destroy

  validates_presence_of :title, :address

  after_initialize :set_address_attributes

  before_create :set_position

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :person, :reject_if => :all_blank, :allow_destroy => true

  accepts_nested_attributes_for :emails,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  accepts_nested_attributes_for :phones,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  delegate :destroy, :attributes, :postcode, :region, :district, :locality, :street, :house, :building,
           :to => :address,
           :prefix => true,
           :allow_nil => true

  delegate :full_name, :surname, :name, :patronymic, :to => :person, :allow_nil => true

  delegate :boost, :to => :subdivision

  default_scope order('position')

  searchable do
    boost :boost

    text :surname, :boost => 1.4
    text :name, :boost => 1.2
    text :patronymic
    text :title, :boost => 1.4
    text :address
    text :phones do phones.join(' ') end
    text :emails do emails.join(' ') end
  end

  def display_name
    title
  end

  alias :to_s :display_name

  private
    def set_address_attributes
      self.address_attributes = subdivision.address_attributes.merge(:id => nil, :office => nil) unless address
    end

    def set_position
      self.position = subdivision.items.last.try(:position).to_i + 1
    end
end

# == Schema Information
#
# Table name: items
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  subdivision_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  position       :integer
#

