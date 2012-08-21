# encoding: utf-8

desc 'Импорт структуры ТУСУР'
task :import_tusur => :environment do
  departments_yml = YAML.load_file(Rails.root.join('stuff/departments.yml'))
  root_category = Category.root
  tusur = root_category.subdivisions.find_or_initialize_by_title_and_abbr(:title => 'Томский государственный университет систем управления и радиоэлектроники', :abbr => 'ТУСУР').tap do |item|
    item.save(:validate => false)
  end
  faculties = Category.find_or_initialize_by_title(:title => 'Факультеты и кафедры').tap do |category|
    category.parent = tusur
    category.save!
  end

  departments_yml.each do |faculty|
    faculty_item = faculties.subdivisions.find_or_initialize_by_title_and_abbr(:title => faculty['title'], :abbr => faculty['abbr']).tap do |item|
      item.save(:validate => false)
    end
    faculty['subdepartments'].each do |subdepartment|
      faculty_item.subdivisions.find_or_initialize_by_title_and_abbr(:title => subdepartment['title'], :abbr => subdepartment['abbr']).tap do |item|
        item.save(:validate => false)
      end
    end
  end
end
