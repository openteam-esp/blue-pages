# encoding: utf-8

require 'spec_helper'

describe Phone do
  def phone(attributes={})
    @phone ||= Phone.new(attributes)
  end

  def create_phone(attributes)
    phone(attributes).save!
    phone
  end

  it { should validate_presence_of :number }
  it { should validate_presence_of :kind }

  describe "код города необязателен только для внутреннего телефона" do
    it { phone(:code => '123', :number => '33-33-11', :kind => :phone).should be_valid }
    it { phone(:number => '33-33-11', :kind => :phone).should_not be_valid }
    it { phone(:number => '33-33-11', :kind => :internal).should be_valid }
  end

  describe "код должен сбросится если телефон внутренний" do
    it { create_phone(:code => '123', :number => '33-33-11', :kind => :phone).code.should_not be_nil }
    it { create_phone(:code => '123', :number => '33-33-11', :kind => :internal).code.should be_nil }
  end
end

# == Schema Information
#
# Table name: phones
#
#  id             :integer         not null, primary key
#  code           :string(255)
#  number         :string(255)
#  phoneable_id   :integer
#  phoneable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  kind           :string(255)
#

