# encoding: utf-8

AdminUser.create!(:email => 'demo@demo.de', :password => '123123', :password_confirmation => '123123')

governor = Subdivision.find_or_create_by_title('Губернатор')
  deputy = governor.children.find_or_create_by_title 'Заместитель губернатора Томской области по особо важным проектам'
    deputy.children.find_or_create_by_title 'Департамент природных ресурсов и охраны окружающей среды Томской области'
    deputy.children.find_or_create_by_title 'Комитет по мобилизационной подготовке Администрации Томской области'
    deputy.children.find_or_create_by_title 'Комитет по развитию атомной энергетики'

Subdivision.find_or_create_by_title('Администрация Томской области')
Subdivision.find_or_create_by_title('Законодательная Дума Томской области')
Subdivision.find_or_create_by_title('Избирательная комиссия Томской области')
Subdivision.find_or_create_by_title('Местное самоуправление Томской области')
Subdivision.find_or_create_by_title('Федеральные структуры')
Subdivision.find_or_create_by_title('Уполномоченный по правам человека в Томской области')
Subdivision.find_or_create_by_title('Уполномоченный по правам ребенка в Томской области')
