# encoding: utf-8

require 'spec_helper'

describe Item do
  let(:subdivision) { Fabricate :subdivision }
  let(:subject) { subdivision.items.build }
  let(:child) { Fabricate :subdivision, :parent => subdivision }

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

  describe 'boost' do
    def subdivision(attributes={})
      @subdivision ||= Fabricate(:subdivision, attributes.merge(:address_attributes => Fabricate.attributes_for(:address)))
    end

    def another_subdivision(attributes={})
      @another_subdivision ||= Fabricate(:subdivision, attributes.merge(:address_attributes => Fabricate.attributes_for(:address)))
    end

    def item(subdivision, attributes={})
      subdivision.items.create!(attributes.merge :title => 'прачка')
    end

    it { item(subdivision).boost.should < subdivision.boost }
    it { item(subdivision, :position => 1).boost.should > item(subdivision, :position => 2).boost }
    it { item(subdivision, :position => 9).boost.should > item(subdivision, :position => 10).boost }
    it { item(subdivision, :position => 10).boost.should > item(subdivision, :position => 11).boost }
    it { item(subdivision).boost.should > item(another_subdivision).boost }
    it { item(subdivision, :position => 10).boost.should > item(another_subdivision).boost }
  end

  context 'sending messages' do
    let(:item) { Fabricate :item, :subdivision => child_1 }
    describe '#create' do
      before { child_1 }
      before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :add_item, 1, :subdivision => {:id => 2, :parent_ids => [1]}, :position => 1) }
      specify { item }
    end

    describe '#update' do
      before { item }
      before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :add_item, 1, :subdivision => {:id => 2, :parent_ids => [1]}, :position => 1) }
      specify { item.update_attributes! :title => 'Новая должность' }
    end

    describe '#destroy' do
      before { item }
      before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :remove_item, 1, :subdivision => {:id => 2, :parent_ids => [1]}, :position => 1) }
      specify { item.destroy }
    end
  end
end

# == Schema Information
#
# Table name: items
#
#  id             :integer         not null, primary key
#  subdivision_id :integer
#  title          :text(255)
#  position       :integer
#  weight         :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  image_url      :string(255)
#

