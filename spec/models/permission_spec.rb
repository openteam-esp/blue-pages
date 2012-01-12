require 'spec_helper'

describe Permission do
  it { should belong_to :context }
  it { should belong_to :user }
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer         not null, primary key
#  context_id   :integer
#  context_type :string(255)
#  user_id      :integer
#  role         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

