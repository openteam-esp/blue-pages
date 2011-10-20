# encoding: utf-8

require 'spec_helper'

describe Item do
  it { should have_one(:building) }

  describe 'default values' do
    let(:subdivision) { Fabricate(:subdivision) }
    let(:item) { subdivision.items.build }

    it { item.building_postcode.should == subdivision.building_postcode }
    it { item.building_region.should == subdivision.building_region }
    it { item.building_district.should == subdivision.building_district }
    it { item.building_locality.should == subdivision.building_locality }
    it { item.building_street.should == subdivision.building_street }
    it { item.building_house.should == subdivision.building_house }
    it { item.building_building.should == subdivision.building_building }

    it "building attributes" do
      item.update_attributes(:building_attributes => {:street => 'Новая'})
      item.building_street.should == 'Новая'
      subdivision.reload.building_street.should == 'пл. Ленина'
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
#  office         :string(255)
#

