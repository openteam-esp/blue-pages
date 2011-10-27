# encoding: utf-8
require Rails.root.join 'lib/importers/structure_importer'

Subdivision.governor
Category.administration

Category.government.children.tap do | children |
  children.find_or_create_by_title('Законодательная Дума Томской области')
  children.find_or_create_by_title('Избирательная комиссия Томской области')
  children.find_or_create_by_title('Местное самоуправление Томской области')
  children.find_or_create_by_title('Федеральные структуры')
  children.find_or_create_by_title('Уполномоченный по правам человека в Томской области')
  children.find_or_create_by_title('Уполномоченный по правам ребенка в Томской области')
end

Category.root.children.find_or_create_by_title('Предприятия').children.tap do | children |
  children.find_or_create_by_title('Медицина')
  children.find_or_create_by_title('Образование')
  children.find_or_create_by_title('Предприятия промышленности')
end

AdminUser.find_or_initialize_by_email('demo@demo.de').tap do | user |
  user.update_attributes :name => 'Юзеров Юзер Юзерович',
                         :password => '123123',
                         :password_confirmation => '123123'
  user.categories << Category.root
end

