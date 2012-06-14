require 'spec_helper'

describe StorageSubscriber do
  let(:subdivision) { Fabricate :subdivision, :info_path => '/tel_sprav/ololo/pish-pish' }
  let(:item) { Fabricate :item, :itemable => subdivision }
  let(:person) { Fabricate :person, :item => item, :info_path => '/tel_sprav/ololo/chief' }

  before { person }

  context '#update_content' do
    describe 'for subdivision' do
      before { subdivision.should_receive :send_update_message }

      specify { subject.update_content '/tel_sprav/ololo/pish-pish' }
    end

    describe 'for person' do
      before { person.should_receive :update_info_path }

      specify { subject.update_content '/tel_sprav/ololo/chief' }
    end
  end
end
