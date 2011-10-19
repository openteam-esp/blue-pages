class Person < ActiveRecord::Base
  belongs_to :item
  validates_presence_of :surname, :name, :patronymic

  def to_s
    "#{surname} #{name} #{patronymic}"
  end
end
