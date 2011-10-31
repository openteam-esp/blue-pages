# encoding: utf-8
require Rails.root.join 'lib/importers/structure_importer'

Subdivision.governor
Subdivision.administration

Category.government.subdivisions.tap do | subdivisions |
  subdivisions.find_or_initialize_by_title('Законодательная Дума Томской области').tap do | council |
    council.update_attributes! :address_attributes => Subdivision.governor.address_attributes.merge(:id => nil)
  end
  subdivisions.find_or_initialize_by_title('Избирательная комиссия Томской области').tap do | committee |
    committee.update_attributes! :address_attributes => Subdivision.governor.address_attributes.merge(:id => nil)
  end
end
Category.government.children.tap do | categories |
  categories.find_or_initialize_by_title('Местное самоуправление Томской области').save!
  categories.find_or_initialize_by_title('Федеральные структуры').save!
end
Category.government.subdivisions.tap do | subdivisions |
  subdivisions.find_or_initialize_by_title('Уполномоченный по правам человека в Томской области').tap do | human_rights_commissioner |
    human_rights_commissioner.update_attributes! :address_attributes => Subdivision.governor.address_attributes.merge(:id => nil)
  end
  subdivisions.find_or_initialize_by_title('Уполномоченный по правам ребенка в Томской области').tap do | child_rights_commissioner |
    child_rights_commissioner.update_attributes! :address_attributes => { :postcode => '654050', :street => 'пер. Нахановича', :house => '3а' }
  end
end

enterprises = Category.root.children.find_or_initialize_by_title('Предприятия').tap &:save!
enterprises.children.tap do | categories |
  categories.find_or_initialize_by_title('Медицина').tap &:save!
  categories.find_or_initialize_by_title('Образование').tap &:save!
  categories.find_or_initialize_by_title('Предприятия промышленности').tap &:save!
end

AdminUser.find_or_initialize_by_email('demo@demo.de').tap do | user |
  user.update_attributes! :name => 'Юзеров Юзер Юзерович',
                          :password => '123123',
                          :password_confirmation => '123123'
  user.categories << Category.root
end

