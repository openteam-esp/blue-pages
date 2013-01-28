# encoding: utf-8

class Item < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true

  has_many :emails,   :as => :emailable,   :dependent => :destroy
  has_many :phones,   :as => :phoneable,   :dependent => :destroy

  has_one :address,   :as => :addressable, :dependent => :destroy
  has_one :person,                         :dependent => :destroy

  validates_presence_of :title, :address

  after_initialize :set_address_attributes, :if => :new_record?

  before_create :set_position, :set_weight

  before_update :set_weight

  after_create  :send_messages_on_create

  # NOTE: very strange behaviour in test environment - #send_messages_on_update called twice
  # TODO: remove :if block
  after_update  :send_messages_on_update, :if => -> { (changes.keys - ['updated_at']).any? }
  after_destroy  :send_messages_on_destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :person, :reject_if => :all_blank

  accepts_nested_attributes_for :emails,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  accepts_nested_attributes_for :phones,
                                :reject_if => ->(attr) { attr.values_at(*(attr.keys - %w[id _destroy])).all?(&:blank?) },
                                :allow_destroy => true

  delegate :destroy, :attributes, :postcode, :region, :district, :locality, :street, :house, :building,
           :to => :address,
           :prefix => true,
           :allow_nil => true

  delegate :full_name, :surname, :name, :patronymic, :to => :person, :allow_nil => true

  delegate :weight, :to => :itemable, :prefix => true

  delegate :ancestors_for_tree, :to => :itemable

  default_scope order('weight')

  alias :parent :itemable

  normalize_attribute :image_url

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  delegate :clear, :to => :image, :allow_nil => true, :prefix => true

  attr_accessor :delete_image

  before_update :image_clear, :if => :delete_image

  searchable do
    boost :boost

    text  :full_name, :boost => 1.5
    text  :title,     :boost => 1.5
    text  :address,   :boost => 0.7
    text  :phones,    :boost => 0.7     do phones.join(' ') end
    text  :emails,    :boost => 0.7     do emails.join(' ') end

    text  :term,      :boost => 0.5
  end

  audited

  def display_name
    title
  end

  alias :to_s :display_name

  def boost
    1.1 - decrement / 10
  end

  def to_json
    result = {}
    result['title'] = title

    result['address'] = address.to_s                                               if respond_to?(:address)
    result['phones'] = Phone.present_as_str(phones.select{|a| !a.kind_internal? }) if respond_to?(:phones) && phones.any?
    result['emails'] = emails.map(&:address)                                       if respond_to?(:emails) && emails.any?
    result['surname'] = person.surname
    result['name'] = person.name
    result['patronymic'] = person.patronymic
    result['academic_degree'] = person.academic_degree                             if Settings['app.academical_attributes']
    result['academic_rank'] = person.academic_rank                                 if Settings['app.academical_attributes']
    result['dossier'] = person.dossier                                             if person.dossier?
    result['image_url'] = image_url                                                if image_url.present?

    result
  end

  def send_update_message
    send_messages_on_update
  end

  alias_method :original_person_attributes=, :person_attributes=

  def person_attributes=(attributes)

    if persisted? && attributes['id'] && attributes.merge('id' => '').values.select(&:present?).empty?
      person.destroy
    else
      self.original_person_attributes = attributes
    end
  end

  private
    def term
      "#{full_name} #{title} #{address} #{phones.join(' ')} #{emails.join(' ')}"
    end

    def set_address_attributes
      self.build_address(itemable.address_attributes.symbolize_keys.merge(:id => nil, :office => nil)) if itemable && !address
    end

    def set_position
      self.position = itemable.items.last.try(:position).to_i + 1
    end

    def decrement
      @decrement ||= ("0." + weights.reverse[0..-2].join).to_f
    end

    def set_weight
      self.weight = weights.join('/')
    end

    def weights
      [itemable_weight, sprintf('%02d', position)].join('/').split('/')
    end

    def send_messages_on_create
      itemable.send_update_message
    end

    def send_messages_on_update
      itemable.send_update_message
    end

    def send_messages_on_destroy
      itemable.send_update_message
    end
end

# == Schema Information
#
# Table name: items
#
#  id            :integer         not null, primary key
#  itemable_id   :integer
#  title         :text
#  position      :integer
#  weight        :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  image_url     :string(255)
#  itemable_type :string(255)
#

