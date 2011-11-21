# encoding: utf-8

require 'spec_helper'

describe Subdivision do
  it { should have_many(:phones) }
  it { should have_many(:emails) }

  it { should have_one(:address) }

  it { should validate_presence_of :title }

  it { should allow_value('Название на русском языке').for(:title) }
  it { should allow_value('Название на русском языке с буквой ё').for(:title) }
  it { should allow_value('Название со скобками ()').for(:title) }
  it { should allow_value('Название со дефисом -').for(:title) }
  it { should allow_value('Название с «"кавычками"»').for(:title) }

  it { should_not allow_value('English title').for(:title) }
  it { should_not allow_value('Название с цифрами 123').for(:title) }


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
  let(:child_subdivision) { first_subdivision.children.create! :title => 'Подкатегорий' }

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
  end

  describe '#decrement' do
    it { root.decrement.should == 0 }
    it { first_subdivision.decrement.should == 0.01 }
    it { second_subdivision.decrement.should == 0.02 }
    it { subdivision(:position => 10).decrement.should == 0.1 }
    it { subdivision(:position => 20).decrement.should == 0.2 }
    it { child_subdivision.decrement.should == 0.0101 }
    it { subdivision(:parent => subdivision(:position => 11), :position => 1).decrement.should == 0.0111 }
    it { subdivision(:parent => subdivision(:position => 12), :position => 99).decrement.should == 0.9912 }
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
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  title      :text
#  abbr       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#  position   :integer
#  url        :text
#  type       :string(255)
#  weight     :string(255)
#

