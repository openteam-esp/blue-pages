# encoding: utf-8

class Building < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true

  validates :region, :district, :locality, :street, :house, :presence => true
  validates :postcode, :numericality => true, :length => { :within => 6..6 }, :presence => true

  default_values :postcode => '634***',
                 :region => 'Томская область',
                 :district => 'г. Томск',
                 :locality => 'г. Томск'

end

# == Schema Information
#
# Table name: buildings
#
#  id               :integer         not null, primary key
#  postcode         :string(255)
#  region           :string(255)
#  district         :string(255)
#  locality         :string(255)
#  street           :string(255)
#  house            :string(255)
#  building         :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

