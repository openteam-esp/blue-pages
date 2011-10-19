class Phone < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true
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
#

