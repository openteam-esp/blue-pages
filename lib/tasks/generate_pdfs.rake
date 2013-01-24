# encoding: utf-8

autoload :BluePagesBook, File.expand_path('../../reports/blue_pages_book', __FILE__)

desc "Генерация всех PDF"
task :generate_pdfs => ['generate_pdf:government', 'generate_pdf:family_department']

namespace :generate_pdf do
  desc "Генерация справочника АТО"
  task :government => :environment do
    BluePagesBook.new(:title => 'Справочник телефонов органов государственной власти и органов местного самоуправления Томской области').generate_pdf
  end

  desc "Генерация справочника Департамента семьи и детей"
  task :family_department => :environment do
    BluePagesBook.new(:root => Category.find_by_slug(:family_department)).generate_pdf
  end
end
