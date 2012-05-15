# encoding: utf-8

class Category < ActiveRecord::Base

  default_scope order('weight')

  has_many :permissions, :as => :context

  has_ancestry :cache_depth => true

  after_update :set_subtree_weights, :if => :weight_changed?
  before_create :set_position, :set_weight
  before_update :set_weight

  before_update :send_messages_on_move, :if => :ancestry_changed?
  after_create  :send_messages_on_create
  after_update  :send_messages_on_update, :unless => :ancestry_changed?
  after_destroy  :send_messages_on_destroy

  validates :title, :presence => true, :format => {:with => /^[а-яё[:space:]–\-\(\)«"»,\.]+$/i}

  searchable do
    boost :boost
    text  :title, :boost => 1.5
  end

  normalize_attribute :info_path

  alias_attribute :absolute_depth, :depth

  def display_name
    title
  end

  def self.root
    Category.find_or_create_by_title('Телефонный справочник')
  end

  def subdivisions
    Subdivision.where(:ancestry => child_ancestry)
  end

  def categories
    children.where(:type => nil)
  end

  alias :to_s :display_name

  def boost
    1.1 - decrement / 10
  end

  def to_json(expand, sync=false)
    sync ? json_sync : json_cms(expand)
  end

  def json_sync
    subtree.map do |category|
      {
        :id => category.id,
        :title => category.title,
        :ancestry => category.ancestry,
        :weight => category.weight
      }
    end
  end

  def json_cms_lite(expand)
    result = {}
    result['title'] = title

    result['items'] = [ {
      'person' => chief.person.to_s,
      'title' => chief.title,
      'image_url' => chief.image_url
    } ] if chief

    expand = [expand, 2].min
    result['subdivisions'] = subdivisions.map { |child| child.json_cms_lite(expand - 1) } if expand > 0 && subdivisions.any?

    result
  end

  def json_cms(expand, expand_categories=true)
    expand = expand.to_i

    return json_cms_lite(expand) if expand > 1

    result = {}
    result['title'] = title

    result['address'] = address.to_s                                               if respond_to?(:address)
    result['phones'] = Phone.present_as_str(phones.select{|a| !a.kind_internal? }) if respond_to?(:phones) && phones.any?
    result['emails'] = emails.map(&:address)                                       if respond_to?(:emails) && emails.any?
    result['url']    = url                                                         if url?
    result['dossier'] = dossier                                                    if respond_to?(:dossier) && info_path

    if respond_to?(:items)
      result['items'] = [] if items.any?

      items.each do |item|
        hash = {
          'person' => item.person.to_s,
          'title' => item.title,
          'address' => item.address.to_s,
          'image_url' => item.image_url
        }

        hash.merge!('link' => Rails.application.routes.url_helpers.category_item_path(item.subdivision, item)) if item.try(:person).try(:info_path?)

        hash.merge!('phones' => Phone.present_as_str(item.phones.select{|a| !a.kind_internal? })) if item.phones.any?
        hash.merge!('emails' => item.emails.map(&:address)) if item.emails.any?

        result['items'] << hash
      end
    end

    result['subdivisions'] = subdivisions.map { |child| child.json_cms(expand - 1) } if expand > 0 && subdivisions.any?

    result
  end

  def ancestors_for_tree(user)
    root = ((ancestors + [self]) & user.contexts).first
    ancestors.inject([]) { |ancestors, ancestror| ancestors << ancestror if ([ancestror] + ancestror.ancestors).include?(root); ancestors } << self
  end

  def send_update_message
    send_messages_on_update
  end

  def send_update_message
    send_messages_on_update
  end

  protected
    def set_position
      self.position = siblings.last.try(:position).to_i + 1 unless self.position
    end

    def set_weight
      self.weight = weights.join('/')
    end

    def weights
      [parent_weight, sprintf('%02d', position)].compact.join('/').split('/')
    end

    def decrement
      @decrement ||= ('0.' + weights.reverse[0..-2].join).to_f
    end

    def set_subtree_weights
      unless ancestry_callbacks_disabled?
        reload.descendants.each do |descendant|
          descendant.without_ancestry_callbacks do
            descendant.set_weight
            descendant.save!
          end
        end
      end
    end

    delegate :weight, :to => :parent, :prefix => true, :allow_nil => true

    def send_messages_on_move
      MessageMaker.make_message('esp.blue-pages.cms', :remove_category, id, :parent_ids => ancestry_was.split('/').reverse.map(&:to_i))
    end

    def send_messages_on_create
      MessageMaker.make_message('esp.blue-pages.cms', :add_category, id, :parent_ids => ancestor_ids.reverse)
    end

    alias_method :send_messages_on_update, :send_messages_on_create

    def send_messages_on_destroy
      MessageMaker.make_message('esp.blue-pages.cms', :remove_category, id, :parent_ids => ancestor_ids.reverse)
    end
end

# == Schema Information
#
# Table name: categories
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  title          :text
#  abbr           :string(255)
#  url            :text
#  info_path      :text
#  position       :integer
#  weight         :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

