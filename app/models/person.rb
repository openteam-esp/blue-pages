class Person < ActiveRecord::Base
  belongs_to :item
  validates_presence_of :surname, :name, :patronymic

  def to_s
    "#{surname} #{name} #{patronymic}"
  end
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

