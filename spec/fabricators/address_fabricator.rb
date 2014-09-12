# encoding: utf-8
Fabricator(:address) do
  postcode "634020"
  street "пл. Ленина"
  house "2"
  building "1"
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
