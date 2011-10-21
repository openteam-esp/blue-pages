# encoding: utf-8

class Phone < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true

  validates_presence_of :number, :kind
  validates_presence_of :code, :unless => :kind_internal?

  before_save :reset_code, :if => :kind_internal?

  has_enums

  def to_s
    res = "#{human_kind}: "
    res << "(#{code}) " unless kind_internal?
    res << number
    res << " добавочный #{additional_number}" if additional_number.present?
  end


  private
    def reset_code
      self.code = nil
    end
end

# == Schema Information
#
# Table name: phones
#
#  id                :integer         not null, primary key
#  code              :string(255)
#  number            :string(255)
#  phoneable_id      :integer
#  phoneable_type    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  kind              :string(255)
#  additional_number :string(255)
#

