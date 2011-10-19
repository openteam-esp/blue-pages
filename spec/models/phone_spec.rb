# encoding: utf-8

require 'spec_helper'

describe Phone do
  it { should validate_presence_of :code }
  it { should validate_presence_of :number }
  it { should validate_presence_of :kind }
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

