# == Schema Information
#
# Table name: permissions
#
#  context_id   :integer
#  context_type :string(255)
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  role         :string(255)
#  updated_at   :datetime         not null
#  user_id      :integer
#

require 'spec_helper'

describe Permission do
  it { should belong_to :context }
  it { should belong_to :user }
end
