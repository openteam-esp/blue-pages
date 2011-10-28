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

  describe 'присваивание position' do
    let(:root) { Category.root }
    let(:first_subdivision) { Fabricate(:subdivision, :parent => root) }
    let(:second_subdivision) { Fabricate(:subdivision, :parent => first_subdivision.parent) }
    let(:child_subdivision) { first_subdivision.children.create! :title => 'Подкатегорий' }

    it { root.position.should == 1 }
    it { first_subdivision.position.should == 1 }
    it { second_subdivision.position.should == 2 }
    it { child_subdivision.position.should == 1 }
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
#

