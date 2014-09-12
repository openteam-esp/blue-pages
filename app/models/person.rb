require 'base64'

class Person < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname, :birthdate, :dossier, :academic_degree, :academic_rank

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
    MessageMaker.make_message('esp.blue-pages.cms', 'add_person', item.id, 'subdivision' => { 'id' => subdivision.id, 'parent_ids' => subdivision.ancestor_ids }) if Rails.env.production?
  end

  private
    delegate :send_messages_on_update, :to => :item

    def remove_dossier
      MessageMaker.make_message('esp.blue-pages.cms', 'remove_person', item.id, 'subdivision' => { 'id' => subdivision.id, 'parent_ids' => subdivision.ancestor_ids }) if Rails.env.production?
    end
end

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  item_id         :integer
#  surname         :string(255)
#  name            :string(255)
#  patronymic      :string(255)
#  birthdate       :date
#  info_path       :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  academic_degree :text
#  academic_rank   :text
#  dossier         :text
#
