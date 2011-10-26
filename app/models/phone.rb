# encoding: utf-8

class Phone < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true

  validates :code, :numericality => true, :unless => :kind_internal?
  validates :kind, :number, :presence => true
  validates :number, :format => { :with => /^\d[\d-]*\d$/}, :unless => :kind_mobile?
  validates :number, :format => { :with => /^+?\d[\d-]*\d$/}, :if => :kind_mobile?

  before_save :reset_code_and_additional_number, :if => :kind_internal_or_mobile?

  default_value_for :code, "3822"

  has_enums

  def to_s
    res = "#{human_kind}: "
    res << "(#{code}) " if code.present?
    res << number
    res << " добавочный #{additional_number}" if additional_number.present?
    res
  end

  def kind_internal_or_mobile?
    kind_internal? || kind_mobile?
  end

  private
    def reset_code_and_additional_number
      self.code = nil
      self.additional_number = nil
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

