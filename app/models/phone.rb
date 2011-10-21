# encoding: utf-8

class Phone < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true

  validates :code, :numericality => true, :unless => :kind_internal?
  validates :kind, :presence => true
  validates :number, :format => { :with => /^(\d{2,3}-)*\d{2,4}$/}, :presence => true

  before_save :reset_code, :if => :kind_internal?

  has_enums

  def to_s
    res = "#{human_kind}: "
    res << "(#{code}) " unless kind_internal?
    res << number
    res << " добавочный #{additional_number}" if additional_number.present?
    res
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

