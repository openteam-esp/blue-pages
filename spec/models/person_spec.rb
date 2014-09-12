# encoding: utf-8
require 'spec_helper'

describe Person do
  it { should normalize_attribute(:dossier).from('').to(nil) }
  it { should normalize_attribute(:dossier).from("<p></p>\n<p></p><p>content</p>").to('<p>content</p>') }

  let(:subdivision) { Fabricate :subdivision }
  let(:item)        { Fabricate :item, :itemable => subdivision }
  let(:person)      { Fabricate :person, :item => item }

  def expect_receive(message)
    MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', message, 1, 'subdivision' => {'id' => 2, 'parent_ids' => [1]})
  end

  describe 'should reindex item when updated' do
    before { item.should_receive(:send_messages_on_update).once }

    specify { person.update_attributes :surname => 'updated surname' }
  end

  describe '#update_dossier' do
    before { subdivision }
    before { expect_receive 'add_person' }
    specify { person.update_dossier }
  end

  describe '.create' do
    context 'dossier = nil' do
      before { MessageMaker.should_not_receive(:make_message).with('esp.blue-pages.cms', 'add_person', 1, 'subdivision' => {'id' => 2, 'parent_ids' => [1]}) }
      specify { person }
    end

    context 'dossier = "about"' do
      before { expect_receive 'add_person' }
      specify { Fabricate :person, :item => item, :dossier => 'about' }
    end
  end

  describe '#update_attribute(:dossier, arg)' do
    context 'arg = "new value"' do
      before { person.should_receive :update_dossier }

      specify { person.update_attribute :dossier, 'new value' }
    end

    context 'arg = nil' do
      before { person.update_attribute :dossier, 'blah blah blah'}
      before { expect_receive 'remove_person' }

      specify { person.update_attribute :dossier, nil }
    end
  end
end

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  item_id         :integer
#  surname         :string(255)
#  name            :string(255)
#  patronymic      :string(255)
#  birthdate       :date
#  info_path       :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  academic_degree :text
#  academic_rank   :text
#  dossier         :text
#
