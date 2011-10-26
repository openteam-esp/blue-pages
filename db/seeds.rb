# encoding: utf-8

user = AdminUser.create!(:email => 'demo@demo.de',
                         :name => 'Юзеров Юзер Юзерович',
                         :password => '123123',
                         :password_confirmation => '123123') if AdminUser.find_by_email('demo@demo.de').blank?

government = Subdivision.find_or_create_by_title('Органы власти')
organizations = Subdivision.find_or_create_by_title('Предприятия')

  government.children.find_or_create_by_title('Губернатор')
  government.children.find_or_create_by_title('Администрация Томской области')
  government.children.find_or_create_by_title('Законодательная Дума Томской области')
  government.children.find_or_create_by_title('Избирательная комиссия Томской области')
  government.children.find_or_create_by_title('Местное самоуправление Томской области')
  government.children.find_or_create_by_title('Федеральные структуры')
  government.children.find_or_create_by_title('Уполномоченный по правам человека в Томской области')
  government.children.find_or_create_by_title('Уполномоченный по правам ребенка в Томской области')

  organizations.subdivisions.find_or_create_by_title('Медицина')
  organizations.subdivisions.find_or_create_by_title('Образование')
  organizations.subdivisions.find_or_create_by_title('Предприятия промышленности')

user.subdivisions << government
