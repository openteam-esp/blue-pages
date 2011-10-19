class Item < ActiveRecord::Base
  belongs_to :subdivision
  has_one :person
end
