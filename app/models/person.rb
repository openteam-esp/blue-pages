class Person < ActiveRecord::Base
  belongs_to :item
  validates_presence_of :surname, :name, :patronymic

  def full_name=(full_name)
    self.surname, self.name, self.patronymic = full_name.split
  end

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  alias :to_s :full_name
end

# == Schema Information
#
# Table name: people
#
#  id         :integer         not null, primary key
#  surname    :string(255)
#  name       :string(255)
#  patronymic :string(255)
#  birthdate  :date
#  item_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

