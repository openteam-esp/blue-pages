# encoding: utf-8

require 'spec_helper'

describe Subdivision do
  it { should have_many(:phones) }
  it { should have_many(:emails) }

  it { should have_one(:address) }

  describe "#url" do
    it { should normalize_attribute(:url).from('www.ru').to('http://www.ru') }
    it { should allow_value('http://super-puper-mega-site.com').for(:url) }
    it { should allow_value('http://super-puper-mega-site.com/ololo').for(:url) }
    it { should allow_value('http://site.com/путь/к файлу?param=%dd').for(:url) }
    it { should allow_value('http://чётко.рф/').for(:url) }
    it { should allow_value('http://чётко.рф/ваще').for(:url) }
    it { should allow_value('www.site.com').for(:url) }
    it { should_not allow_value('http://super-puper-mega-site.com%').for(:url) }
    it { should_not allow_value('http://super-puper-mega-site.com_').for(:url) }
    it { should_not allow_value('http://site').for(:url) }
    it { should_not allow_value('http://сайt.рф').for(:url) }
    it { should_not allow_value('http://сайт.ру').for(:url) }
  end

  describe 'вложенные подразделения' do
    describe "подстановка адреса из родительского подразделения" do
      let(:subdivision) { Fabricate(:subdivision, :address_attributes => Fabricate.attributes_for(:address).merge(:office => '123')) }
      let(:child) { subdivision.subdivisions.build :title => 'вложенное подразделение' }

      it { child.address.office.should be_blank }
      it { child.address.building_same_as?(subdivision.address).should be_true }
    end
  end

  let(:root) { Category.root }
  let(:first_subdivision) { Fabricate(:subdivision, :parent => root) }
  let(:second_subdivision) { Fabricate(:subdivision, :parent => first_subdivision.parent) }
  let(:child_subdivision) { first_subdivision.subdivisions.create! :title => 'Подкатегорий' }

  describe 'присваивание position' do
    it { root.position.should == 1 }
    it { first_subdivision.position.should == 1 }
    it { second_subdivision.position.should == 2 }
    it { child_subdivision.position.should == 1 }
  end

  def subdivision(attributes={})
    Fabricate(:subdivision, {:parent => root}.merge(attributes))
  end

  describe '#weight' do
    it { subdivision(:position => 10).position.should == 10 }
    it { root.weight.should == '01' }
    it { first_subdivision.weight.should == '01/01' }
    it { second_subdivision.weight.should == '01/02' }
    it { subdivision(:position => 20).weight.should == '01/20' }
    it { child_subdivision.weight.should == '01/01/01' }
    it { subdivision(:parent => subdivision(:position => 11), :position => 1).weight.should == '01/11/01' }
    it { subdivision(:parent => subdivision(:position => 12), :position => 99).weight.should == '01/12/99' }

    describe 'обновление position должно менять веса у детей' do
      before { child_subdivision.parent.update_attribute(:position, 2) }

      it { child_subdivision.reload.weight.should == '01/02/01' }
      it { first_subdivision.reload.weight.should == '01/02' }
    end
  end

  describe '#decrement' do
    it { root.send(:decrement).should == 0 }
    it { first_subdivision.send(:decrement).should == 0.01 }
    it { second_subdivision.send(:decrement).should == 0.02 }
    it { subdivision(:position => 10).send(:decrement).should == 0.1 }
    it { subdivision(:position => 20).send(:decrement).should == 0.2 }
    it { child_subdivision.send(:decrement).should == 0.0101 }
    it { subdivision(:parent => subdivision(:position => 11), :position => 1).send(:decrement).should == 0.0111 }
    it { subdivision(:parent => subdivision(:position => 12), :position => 99).send(:decrement).should == 0.9912 }
  end

  describe '#boost' do
    it { root.boost.should == 1.1 }
    it { subdivision.boost.should be_within(1.0e-7).of(1.099) }
    it { second_subdivision.boost.should == 1.098 }
    it { subdivision(:position => 99).boost.should be_within(1.0e-7).of(1.001) }
    it { root.boost.should > first_subdivision.boost }
    it { first_subdivision.boost.should > second_subdivision.boost }
    it { first_subdivision.boost.should > child_subdivision.boost }
    it { subdivision(:position => 9).boost.should > subdivision(:position => 10).boost }
    it { child_subdivision.boost.should > subdivision(:position => 10).boost }
  end

  describe 'создание категорий в подразделении' do
    let(:subdivision) { Fabricate(:subdivision) }
    let(:category_in_subdivision) { Fabricate(:category, :parent => subdivision) }

    it { category_in_subdivision.should be_valid }
  end

  describe 'изменение родителя' do
    let(:root) { Category.root }

    let(:category_1) { Fabricate :category, :parent => root }
    let(:category_2) { Fabricate :category, :parent => root }

    let(:subdivision_1_1) { Fabricate :subdivision, :parent => category_1 }
    let(:subdivision_1_1_1) { Fabricate :subdivision, :parent => subdivision_1_1 }
    let(:subdivision_1_1_2) { Fabricate :subdivision, :parent => subdivision_1_1 }

    before { category_1 and category_2 and subdivision_1_1 and subdivision_1_1_1 and subdivision_1_1_2 }
    before { subdivision_1_1.update_attributes(:parent_id => category_2.id) }

    it { category_2.reload.children.should == [subdivision_1_1] }

    it { subdivision_1_1.reload.parent.should == category_2 }
    it { subdivision_1_1.reload.ancestry.should == '1/3' }
    it { subdivision_1_1.reload.weight.should == '01/02/01' }

    it { subdivision_1_1_1.reload.parent.should == subdivision_1_1 }
    it { subdivision_1_1_1.reload.ancestry.should == '1/3/4' }
    it { subdivision_1_1_1.reload.weight.should == '01/02/01/01' }

    it { subdivision_1_1_2.reload.parent.should == subdivision_1_1 }
    it { subdivision_1_1_2.reload.ancestry.should == '1/3/4' }
    it { subdivision_1_1_2.reload.weight.should == '01/02/01/02' }
  end
end

# == Schema Information
#
# Table name: categories
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  title          :text
#  abbr           :string(255)
#  url            :text
#  info_path      :text
#  position       :integer
#  weight         :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

