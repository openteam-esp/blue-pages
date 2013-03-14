# encoding: utf-8
# == Schema Information
#
# Table name: phones
#
#  additional_number :string(255)
#  code              :string(255)
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  kind              :string(255)
#  number            :string(255)
#  phoneable_id      :integer
#  phoneable_type    :string(255)
#  updated_at        :datetime         not null
#


class Phone < ActiveRecord::Base
  VALID_NUMBER = /\A\d[\d-]*\d\z/
  VALID_MOBILE_NUMBER = /\A\+?\d[\d-]*\d\z/

  attr_accessible :additional_number, :code, :kind, :number

  belongs_to :phoneable, :polymorphic => true

  validates :code, :numericality => true, :unless => :kind_internal?
  validates :kind, :number, :presence => true
  validates :number, :format => {:with => VALID_NUMBER}, :unless => :kind_mobile?
  validates :number, :format => {:with => VALID_MOBILE_NUMBER}, :if => :kind_mobile?

  before_save :reset_code_and_additional_number, :if => :kind_internal_or_mobile?

  after_create :send_messages_on_create
  after_update :send_messages_on_update
  after_destroy :send_messages_on_destroy

  default_value_for :code, "3822"

  has_enums

  def to_s
    res = ""
    res << "(#{code}) " if code.present?
    res << number
    res << " добавочный #{additional_number}" if additional_number.present?
    res
  end

  def kind_internal_or_mobile?
    kind_internal? || kind_mobile?
  end

  def self.present_as_str(phones)
    phones.group_by(&:kind).map do |kind, phones|
      "#{Phone.human_enums[:kind][kind.to_sym]}: #{phones.join(', ')}"
    end.join('; ')
  end

  private
    delegate :send_messages_on_create, :send_messages_on_update, :send_messages_on_destroy, :to => :phoneable

    def reset_code_and_additional_number
      self.code = nil
      self.additional_number = nil
    end
end
