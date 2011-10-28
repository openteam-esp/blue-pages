# encoding: utf-8

require 'spec_helper'

describe Item do
  let(:subdivision) { Fabricate(:subdivision, :address_attributes => Fabricate.attributes_for(:address).merge(:office => '123')) }
  let(:subject) { subdivision.items.build }
  let(:child) { subdivision.children.create!(:title => 'вложенное подразделение') }

  def create_item(attributes={})
    subdivision.items.create! attributes
  end

  it { should have_one(:address) }
  it { should validate_presence_of :address }

  describe 'присваивание position' do
    let(:first_item) { create_item :title => 'секретарь 1' }
    let(:second_item) { first_item.subdivision.items.create! :title => 'секретарь 2' }
    let(:other_item) { child.items.create! :title => 'бухгалтер' }

    it { first_item.position.should == 1 }
    it { second_item.position.should == 2 }
    it { other_item.position.should == 1 }
  end

  describe "подстановка адреса из подразделения" do
    it { subject.address.office.should be_blank }
    it { subject.address.building_same_as?(subdivision.address).should be_true }
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

