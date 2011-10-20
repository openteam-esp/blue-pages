class Phone < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true

  validates_presence_of :code, :number, :kind

  has_enums

  def to_s
    "#{human_kind}: (#{code}) #{number}"
  end
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

