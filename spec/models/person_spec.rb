#encoding: utf-8

require 'spec_helper'

describe Person do
  it { should normalize_attribute(:info_path).from('').to(nil) }

  describe 'should reindex item when updated' do
    let(:item) { Fabricate :item }
    let(:person) { Fabricate :person, :item => item }

    before { item.should_receive(:send_messages_on_update).once }

    specify { person.update_attributes :surname => 'updated surname' }
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

