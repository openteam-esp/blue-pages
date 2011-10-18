class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
end
# == Schema Information
#
# Table name: addresses
#
#  id               :integer         not null, primary key
#  postcode         :string(255)
#  region           :string(255)
#  district         :string(255)
#  locality         :string(255)
#  street           :string(255)
#  house            :string(255)
#  building         :string(255)
#  flat             :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#
