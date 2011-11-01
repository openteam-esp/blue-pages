# encoding: utf-8

desc "Генерация справочника pdf"
task :generate_pdf => :environment do
  output = BluePagesBook.new(:page_size => 'A4', :margin => [50,38,25,50]).to_pdf
  File.open(Rails.root.join('public/blue_pages.pdf'), 'wb') {|f| f.write(output) }
end

