# encoding: utf-8
class Address < ActiveRecord::Base
  attr_accessible :building, :district, :house, :locality, :office, :postcode, :region, :street

  belongs_to :addressable, :polymorphic => true

  validates :region, :district, :locality, :street, :house, :presence => true
  validates :postcode, :numericality => true, :length => { :within => 6..6 }, :presence => true

  after_update :send_messages_on_update

  default_values :postcode => '634***',
                 :region => 'Томская область',
                 :district => 'г. Томск',
                 :locality => 'г. Томск'

  normalize_attributes :building, :district, :house, :locality, :office, :postcode, :region, :street

  SIGNIFICANT_ATTRIBUTES = %w[postcode region district locality street house building]

  def significant_values
    attributes.values_at *SIGNIFICANT_ATTRIBUTES
  end

  def building_same_as?(other)
    other && self.significant_values == other.significant_values
  end

  def full_address
    result = significant_values[0..-2].uniq
    result << "стр.#{building}" unless building.blank?
    result << "кабинет #{office}" unless office.blank?
    result.join(", ")
  end

  def to_s
    result = []
    unless addressable.is_a?(Item) && building_same_as?(addressable.itemable.address)
      result = significant_values[0..-2].uniq
      result << "стр.#{building}" unless building.blank?
    end
    result << "кабинет #{office}" unless office.blank?
    result.delete_if{ |item| item.blank? }.join(', ')
  end

  private
    delegate :send_messages_on_update, :to => :addressable
end

# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  postcode         :string(255)
#  region           :string(255)
#  district         :string(255)
#  locality         :string(255)
#  street           :string(255)
#  house            :string(255)
#  building         :string(255)
#  office           :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
