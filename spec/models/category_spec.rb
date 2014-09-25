# encoding: utf-8
require 'spec_helper'

describe Category do
  it { should have_many :permissions }
  it { should validate_presence_of :title }
  it { should allow_value('Название на русском языке').for(:title) }
  it { should allow_value('Название на русском языке с буквой ё').for(:title) }
  it { should allow_value('Название со скобками ()').for(:title) }
  it { should allow_value('Название со дефисом -').for(:title) }
  it { should allow_value('Название с «"кавычками"»').for(:title) }
  it { should allow_value('Название с точкой.').for(:title) }
  it { should_not allow_value('English title').for(:title) }
  it { should allow_value('Название с цифрами 123').for(:title) }

  it { should normalize_attribute(:dossier).from('').to(nil) }
  it { should normalize_attribute(:dossier).from("<p></p>\n<p></p><p>content</p>").to('<p>content</p>') }

  let(:child_1) { Fabricate :category, :parent => root }
  let(:child_2) { Fabricate :subdivision, :parent => root }
  let(:child_1_1) { Fabricate :subdivision, :parent => child_1 }

  context 'sending messages' do
    describe '#create' do
      before { child_1 }
      before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :add_category, 3, :parent_ids => [2, 1]) }
      specify { child_1_1 }
    end

    describe '#update' do
      before { child_1 }

      context 'updated name' do
        before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :add_category, 2, :parent_ids => [1]) }
        specify { child_1.update_attributes! :title => 'Новое название' }
      end

      context 'updated ancestry' do
        before { child_2 }
        before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :remove_category, 2, :parent_ids => [1]) }
        before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :add_category, 2, :parent_ids => [3, 1]) }
        specify { child_1.update_attributes! :parent_id => child_2.id }
      end
    end

    describe '#destroy' do
      before { child_1 }
      before { MessageMaker.should_receive(:make_message).with('esp.blue-pages.cms', :remove_category, 2, :parent_ids => [1]) }
      specify { child_1.destroy }
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  type               :string(255)
#  title              :text
#  abbr               :string(255)
#  url                :text
#  info_path          :text
#  position           :integer
#  weight             :string(255)
#  ancestry           :string(255)
#  ancestry_depth     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  kind               :string(255)
#  status             :text
#  sphere             :text
#  production         :text
#  image_url          :text
#  slug               :string(255)
#  dossier            :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  mode               :text
#  appointments       :text
#
