require 'base64'

class Person < ActiveRecord::Base
  belongs_to :item

  validates_presence_of :surname, :name, :patronymic

  after_update :send_messages_on_update

  after_save :update_info_path, :if => [:info_path_changed?, :info_path?]

  after_update :remove_info_path, :if => :info_path_changed?, :unless => :info_path?

  normalize_attribute :info_path

  delegate :itemable, :to => :item
  alias :subdivision :itemable

  def full_name=(full_name)
    self.surname, self.name, self.patronymic = full_name.split
  end

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  alias :to_s :full_name

  def update_info_path
    MessageMaker.make_message 'esp.blue-pages.cms', 'add_person', item.id, 'subdivision' => { 'id' => subdivision.id, 'parent_ids' => subdivision.ancestor_ids }
  end

  private
    def str_to_hash(str)
      Base64.urlsafe_encode64(str).strip.tr('=', '')
    end

    def remote_url
      "#{Settings['storage.url']}/api/el_finder/v2?format=json&cmd=get"
    end

    delegate :send_messages_on_update, :to => :item

    def remove_info_path
      MessageMaker.make_message 'esp.blue-pages.cms', 'remove_person', item.id, 'subdivision' => { 'id' => subdivision.id, 'parent_ids' => subdivision.ancestor_ids }
    end
end

# == Schema Information
#
# Table name: people
#
#  id         :integer         not null, primary key
#  item_id    :integer
#  surname    :string(255)
#  name       :string(255)
#  patronymic :string(255)
#  birthdate  :date
#  info_path  :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

