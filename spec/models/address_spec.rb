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
    it { subject.postcode.should == '634***' }
    it { subject.region.should == 'Томская область' }
    it { subject.district.should == 'г. Томск' }
    it { subject.locality.should == 'г. Томск' }
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

