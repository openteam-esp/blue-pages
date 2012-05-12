# encoding: utf-8

require 'spec_helper'

describe Address do
  it { should validate_presence_of :postcode }
  it { should validate_presence_of :region }
  it { should validate_presence_of :district }
  it { should validate_presence_of :locality }
  it { should validate_presence_of :street }
  it { should validate_presence_of :house }

  it { should allow_value('123456').for(:postcode) }
  it { should_not allow_value('12345').for(:postcode) }
  it { should_not allow_value('123ab').for(:postcode) }

  describe 'default values' do
    its(:postcode)  { should == '634***' }
    its(:region)    { should == 'Томская область' }
    its(:district)  { should == 'г. Томск' }
    its(:locality)  { should == 'г. Томск' }
  end

  let(:subdivision) { Fabricate(:subdivision) }

  context 'of subdivision' do
    subject { subdivision.address }

    its(:to_s) { should == "634020, Томская область, г. Томск, пл. Ленина, 2, стр.1" }

    describe 'sending messages' do
      before { subdivision.should_receive :send_messages_on_update }

      specify { subject.update_attributes! :postcode => '777777' }
    end
  end

  context 'of item' do
    subject { item.address }
    context 'when equal building' do
      let(:item) do
        subdivision.items.create(:title => "должность").tap do | item |
          item.address.office = "210"
          item.save
        end
      end
      its(:to_s) { should == "кабинет 210" }
    end
    context 'when not equal building' do
      let(:item) { subdivision.items.create(:title => "должность", :address_attributes => {:postcode => "634050", :street => "пр. Ленина", :house => "40", :office => "206"}) }
      its(:to_s) { should == '634050, Томская область, г. Томск, пр. Ленина, 40, кабинет 206' }
    end
  end
end

# == Schema Information
#
# Table name: buildings
#
#  id               :integer         not null, primary key
#  postcode         :string(255)
#  region           :string(255)
#  district         :string(255)
#  locality         :string(255)
#  street           :string(255)
#  house            :string(255)
#  building         :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  office           :string(255)
#

