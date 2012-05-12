require 'spec_helper'

describe Email do
  it { should belong_to(:emailable)}

  it { should validate_presence_of :address }

  it { should allow_value('mail@mail.com').for(:address) }
  it { should_not allow_value('mail.com').for(:address) }

  context 'of subdivision' do
    let(:subdivision) { Fabricate(:subdivision) }

    subject { subdivision.emails.create! :address => 'ololo@mailinator.com' }

    describe 'sending messages' do
      describe '#create' do
        before { subdivision.should_receive :send_messages_on_create }
        specify { subject }
      end
      describe '#update' do
        before { subject }
        before { subdivision.should_receive :send_messages_on_update }
        specify { subject.update_attributes :address => 'ololol@mail.ru' }
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
# Table name: emails
#
#  id             :integer         not null, primary key
#  address        :string(255)
#  emailable_id   :integer
#  emailable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

