# encoding: utf-8

class Category < ActiveRecord::Base
  has_and_belongs_to_many :users, :uniq => true

  validates :title, :presence => true, :format => {:with => /^[а-яё[:space:]–\-\(\)«"»,]+$/i}

  default_scope order('weight')

  before_create :set_position, :set_weight
  before_update :set_weight

  has_ancestry :cache_depth => true

  delegate :weight, :to => :parent, :prefix => true, :allow_nil => true

  searchable do
    boost :boost
    text  :title, :boost => 1.5
  end

  def display_name
    title
  end

  def self.root
    Category.find_or_create_by_title('Телефонный справочник')
  end

  def subdivisions
    Subdivision.where(:ancestry => child_ancestry)
  end

  alias :to_s :display_name
  alias :categories :children

  def boost
    1.1 - decrement / 10
  end

  def to_json(expand = false)
    result = {}
    result['title'] = title

    result['address'] = address.to_s                                               if respond_to?(:address)
    result['phones'] = Phone.present_as_str(phones.select{|a| !a.kind_internal? }) if respond_to?(:phones) && phones.any?
    result['emails'] = emails.map(&:address)                                       if respond_to?(:emails) && emails.any?
    result['dossier'] = dossier                                                    if respond_to?(:dossier) && info_path

    if respond_to?(:items)
      result['items'] = [] if items.any?

      items.each do |item|
        hash = { 'person' => item.person.to_s, 'title' => item.title, 'address' => item.address.to_s, 'link' => Rails.application.routes.url_helpers.category_item_path(item.subdivision, item) }

        hash.merge!('phones' => Phone.present_as_str(item.phones.select{|a| !a.kind_internal? })) if item.phones.any?
        hash.merge!('emails' => item.emails.map(&:address)) if item.emails.any?

        result['items'] << hash
      end
    end

    result['subdivisions'] = children.map { |child| child.to_json(expand) } if expand && children.any?

    result
  end

  def ancestors_for_tree(user)
    ancestors.inject([]) { |sum, c| sum << c if sum.any? || c.users.where(:id => user.id).exists?; sum } << self
  end

  def subdivisions_and_categories
    subdivisions + categories
  end

  protected
    def set_position
      self.position = siblings.last.try(:position).to_i + 1 unless self.position
    end

    def set_weight
      self.weight = weights.join('/')
    end

    def weights
      @weights ||= [parent_weight, sprintf('%02d', position)].keep_if(&:present?).join('/').split('/')
    end

    def decrement
      @decrement ||= ("0." + weights.reverse[0..-2].join).to_f
    end
end

# == Schema Information
#
# Table name: categories
#
#  id             :integer         not null, primary key
#  title          :text
#  abbr           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  ancestry       :string(255)
#  position       :integer
#  url            :text
#  type           :string(255)
#  weight         :string(255)
#  info_path      :string(255)
#  ancestry_depth :integer         default(0)
#

