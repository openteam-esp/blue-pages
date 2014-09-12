# encoding: utf-8
require 'spec_helper'

describe Phone do
  def phone(attributes={})
    @phone ||= Phone.new(attributes)
  end

  def create_phone(attributes)
    Fabricate :phone, attributes
  end

  it { should validate_presence_of :number }
  it { should validate_presence_of :kind }

  describe "код города необязателен только для внутреннего телефона" do
    it { phone(:code => '123', :number => '33-33-11', :kind => :phone).should be_valid }
    it { phone(:code => '', :number => '33-33-11', :kind => :phone).should_not be_valid }
    it { phone(:number => '33-33-11', :kind => :internal).should be_valid }
  end

  describe "код должен сбросится если телефон внутренний" do
    it { create_phone(:code => '123', :number => '33-33-11', :kind => :internal).code.should be_nil }
    it { create_phone(:code => '123', :number => '33-33-11', :kind => :phone).code.should_not be_nil }
  end

  describe "если телефон мобильный должен сбросится" do
    it { phone(:number => '88-99-00') }
    it "код" do
      create_phone(:code => '123', :number => '8-900-333-30-11', :kind => :mobile).code.should be_nil
    end
    it "добавочни" do
      create_phone(:number => '8-900-333-30-11', :additional_number => '#22', :kind => :mobile).additional_number.should be_nil
    end
  end

  describe "#code" do
    it { should_not allow_value("1-123").for(:code) }
  end

  describe "#number" do
    it { should_not allow_value("l1-123").for(:number) }
    it { should_not allow_value("+7-11123").for(:number) }
    it { should_not allow_value("-11-123").for(:number) }
    it { should_not allow_value("11-123-").for(:number) }
    it { should allow_value("11-123").for(:number) }
    it { should allow_value("1234").for(:number) }
  end

  context 'of subdivision' do
    let(:subdivision) { Fabricate(:subdivision) }
    subject { subdivision.phones.create! :number => '1234', :kind => :internal }

    describe 'sending messages' do
      describe '#create' do
        before { subdivision.should_receive :send_messages_on_create }
        specify { subject }
      end
      describe '#update' do
        before { subject }
        before { subdivision.should_receive :send_messages_on_update }
        specify { subject.update_attributes :number => '3214' }
      end
      describe '#destroy' do
        before { subject }
        before { subdivision.should_receive :send_messages_on_destroy }
        specify { subject.destroy }
      end
    end
  end
end

# == Schema Information
#
# Table name: phones
#
#  id                :integer          not null, primary key
#  phoneable_id      :integer
#  phoneable_type    :string(255)
#  kind              :string(255)
#  code              :string(255)
#  number            :string(255)
#  additional_number :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
