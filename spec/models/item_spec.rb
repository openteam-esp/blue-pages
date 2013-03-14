# encoding: utf-8
# == Schema Information
#
# Table name: items
#
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_url          :string(255)
#  itemable_id        :integer
#  itemable_type      :string(255)
#  position           :integer
#  title              :text
#  updated_at         :datetime         not null
#  weight             :string(255)
#


require 'spec_helper'

describe Item do
  let(:subdivision) { Fabricate :subdivision }
  let(:item) { subdivision.items.build :title => 'должность' }
  let(:child) { Fabricate :subdivision, :parent => subdivision }

  subject { item }

  def create_item(attributes={})
    subdivision.items.create! attributes
  end

  it { should have_one(:address) }
  it { should validate_presence_of :address }

  describe '#person_attributes' do
    let(:person_attributes) { {:surname => 'Иванов', :name => 'Иван', :patronymic => 'Иванович'} }
    it { should allow_value(person_attributes).for(:person_attributes) }
    context 'should destroy person if empty person_attributes' do
      let(:person) { item.build_person(person_attributes) }
      before { item.save! }
      before { person.save! }
      before { subject.update_attributes! :person_attributes => {'name' => '', 'surname' => '', 'patronymic' => '', 'birthday' => '', 'id' => person.id} }

      specify { subject.reload.person.should be_nil }
      specify { person.should_not be_persisted }
    end
  end

  describe 'присваивание position' do
    let(:first_item) { create_item :title => 'секретарь 1' }
    let(:second_item) { first_item.itemable.items.create! :title => 'секретарь 2' }
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
    let(:item) { Fabricate :item, :itemable => child_1 }
    describe '#create' do
      before { child_1 }
      before { child_1.should_receive(:send_update_message) }
      specify { item }
    end

    describe '#update' do
      before { item }
      before { child_1.should_receive(:send_update_message) }
      specify { item.update_attributes! :title => 'Новая должность' }
    end

    describe '#destroy' do
      before { item }
      before { child_1.should_receive(:send_update_message) }
      specify { item.destroy }
    end
  end
end
