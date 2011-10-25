# encoding: utf-8

require 'spec_helper'

describe Item do
  let(:subdivision) { Fabricate(:subdivision) }
  let(:item) { subdivision.items.build(:title => 'Заместитель') }

  it { should have_one(:building) }

  it { subdivision; expect { item.save! }.to_not change{ Building.count } }

  describe 'default values' do
    it { item.building_postcode.should == subdivision.building_postcode }
    it { item.building_region.should == subdivision.building_region }
    it { item.building_district.should == subdivision.building_district }
    it { item.building_locality.should == subdivision.building_locality }
    it { item.building_street.should == subdivision.building_street }
    it { item.building_house.should == subdivision.building_house }
    it { item.building_building.should == subdivision.building_building }

    it "building attributes" do
      item.update_attributes!(:building_attributes => item.building_attributes.merge(:street => 'Новая'))
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
#  position       :integer
#

