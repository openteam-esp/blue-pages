require 'spec_helper'

describe Permission do
  it { should belong_to :context }
  it { should belong_to :user }
end

# == Schema Information
#
# Table name: permissions
#
#  id         :integer         not null, primary key
#  context_id :integer
#  user_id    :integer
#  role       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

