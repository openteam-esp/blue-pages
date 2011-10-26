# encoding: utf-8

require 'spec_helper'

describe Item do
  let(:subdivision) { Fabricate(:subdivision) }
  let(:item) { subdivision.items.build(:title => 'Заместитель') }

  it { should have_one(:address) }

  describe 'default values' do
    it { item.address_postcode.should == subdivision.address_postcode }
    it { item.address_region.should == subdivision.address_region }
    it { item.address_district.should == subdivision.address_district }
    it { item.address_locality.should == subdivision.address_locality }
    it { item.address_street.should == subdivision.address_street }
    it { item.address_house.should == subdivision.address_house }
    it { item.address_building.should == subdivision.address_building }

    it "address attributes" do
      item.update_attributes!(:address_attributes => item.address_attributes.merge(:street => 'Новая'))
      item.address_street.should == 'Новая'
      subdivision.reload.address_street.should == 'пл. Ленина'
    end
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

