# == Schema Information
#
# Table name: people
#
#  academic_degree :text
#  academic_rank   :text
#  birthdate       :date
#  created_at      :datetime         not null
#  dossier         :text
#  id              :integer          not null, primary key
#  info_path       :text
#  item_id         :integer
#  name            :string(255)
#  patronymic      :string(255)
#  surname         :string(255)
#  updated_at      :datetime         not null
#

require 'base64'

class Person < ActiveRecord::Base
  belongs_to :item

  validates_presence_of :surname, :name, :patronymic

  after_update :send_messages_on_update

  after_save :update_dossier, :if => [:dossier_changed?, :dossier?]

  after_update :remove_dossier, :if => :dossier_changed?, :unless => :dossier?

  normalize_attribute :dossier, :with => [:strip_empty_html, :strip, :blank]

  delegate :itemable, :to => :item
  alias :subdivision :itemable

  def full_name=(full_name)
    self.surname, self.name, self.patronymic = full_name.split
  end

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  alias :to_s :full_name

  def update_dossier
    MessageMaker.make_message 'esp.blue-pages.cms', 'add_person', item.id, 'subdivision' => { 'id' => subdivision.id, 'parent_ids' => subdivision.ancestor_ids }
  end

  private
    delegate :send_messages_on_update, :to => :item

    def remove_dossier
      MessageMaker.make_message 'esp.blue-pages.cms', 'remove_person', item.id, 'subdivision' => { 'id' => subdivision.id, 'parent_ids' => subdivision.ancestor_ids }
    end
end
