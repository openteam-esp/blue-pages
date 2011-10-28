# encoding: utf-8

require 'spec_helper'

describe Item do
  let(:subdivision) { Fabricate(:subdivision) }
  let(:item) { subdivision.items.build(:title => 'Заместитель') }
  let(:subject) { subdivision.items.build }

  it { should have_one(:address) }
  it { should validate_presence_of :address }

  describe "подстановка адреса из подразделения" do
    let(:subdivision) { Fabricate(:subdivision, :address_attributes => Fabricate.attributes_for(:address).merge(:office => '123')) }
    let(:item) { subdivision.items.build :title => 'секретарь' }

    it { item.address.office.should be_blank }
    it { item.address.building_same_as?(subdivision.address).should be_true }
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

