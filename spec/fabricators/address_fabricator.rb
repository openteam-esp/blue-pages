# encoding: utf-8
# == Schema Information
#
# Table name: addresses
#
#  addressable_id   :integer
#  addressable_type :string(255)
#  building         :string(255)
#  created_at       :datetime         not null
#  district         :string(255)
#  house            :string(255)
#  id               :integer          not null, primary key
#  locality         :string(255)
#  office           :string(255)
#  postcode         :string(255)
#  region           :string(255)
#  street           :string(255)
#  updated_at       :datetime         not null
#


Fabricator(:address) do
  postcode "634020"
  street "пл. Ленина"
  house "2"
  building "1"
end
