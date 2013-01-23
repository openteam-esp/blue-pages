# encoding: utf-8

autoload :Prawn, 'prawn'
autoload :BluePagesBook, File.expand_path('../../reports/blue_pages_book', __FILE__)
autoload :DepartmentBook, File.expand_path('../../reports/department_book', __FILE__)

def generate(book)
  raise "Couldn't find slug for #{book.category.class}##{book.category.id}" unless book.category.slug
  File.open(Rails.root.join("public/#{book.category.slug}.pdf"), 'wb') {|f| f.write(book.to_pdf) }
end

desc "Генерация всех PDF"
task :generate_books => ['generate_book:blue_pages', 'generate_book:family_department']

namespace :generate_book do
  desc "Генерация справочника АТО"
  task :blue_pages => :environment do
    generate(BluePagesBook.new)
  end

  desc "Генерация справочника Департамента семьи и детей"
  task :family_department => :environment do
    generate(DepartmentBook.new(:category => Category.find_by_slug(:family_department)))
  end
end
