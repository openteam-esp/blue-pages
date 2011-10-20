require 'spec_helper'

describe Email do
  it { should belong_to(:emailable)}

  it { should validate_presence_of :address }

  it { should allow_value('mail@mail.com').for(:address) }
  it { should_not allow_value('mail.com').for(:address) }
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

