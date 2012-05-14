# encoding: utf-8

require 'spec_helper'

describe Person do
  it { should normalize_attribute(:info_path).from('').to(nil) }

  let(:item) { Fabricate :item }
  let(:person) { Fabricate :person, :item => item }

  describe 'should reindex item when updated' do
    before { item.should_receive(:send_messages_on_update).once }

    specify { person.update_attributes :surname => 'updated surname' }
  end

  describe '#update_info_path' do
    before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', 'update_item', 1) }

    specify { person.update_info_path }
  end

  describe '#update_attribute(:info_path, arg)' do
    context 'arg=new_value' do
      before { person.should_receive :update_info_path }

      specify { person.update_attribute :info_path, 'new info path' }
    end

    context 'arg=nil' do
      before { person.update_attribute :info_path, 'blah blah blah'}
      before { person.should_receive :remove_info_path }

      specify { person.update_attribute :info_path, nil }
    end
  end
end

# == Schema Information
#
# Table name: people
#
#  id         :integer         not null, primary key
#  item_id    :integer
#  surname    :string(255)
#  name       :string(255)
#  patronymic :string(255)
#  birthdate  :date
#  info_path  :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

