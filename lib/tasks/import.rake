# encoding: utf-8

desc "Импорт структуры подразделений с http://tomsk.gov.ru/ru/rule/structure"
task :import => :environment do
  require Rails.root.join 'lib/importers/structure_importer'
  StructureImporter.new.import
end
