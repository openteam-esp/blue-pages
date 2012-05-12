require 'base64'

class Person < ActiveRecord::Base
  belongs_to :item

  validates_presence_of :surname, :name, :patronymic

  normalize_attribute :info_path

  def full_name=(full_name)
    self.surname, self.name, self.patronymic = full_name.split
  end

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  alias :to_s :full_name

  def dossier
    c = Curl::Easy.perform("#{remote_url}&target=r1_#{str_to_hash(info_path.gsub(/^\//,''))}")
    JSON.parse(c.body_str)['content']
  end

  private
    def str_to_hash(str)
      Base64.urlsafe_encode64(str).strip.tr('=', '')
    end

    def remote_url
      "#{Settings['storage.url']}/api/el_finder/v2?format=json&cmd=get"
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

