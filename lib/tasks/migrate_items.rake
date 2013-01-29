require 'progress_bar'
require 'timecop'
require 'open-uri'

class ItemsMigrator
  def migrate
    puts "Migrate items"
    bar = ProgressBar.new(objects.count)
    objects.each do |object|
      Timecop.freeze(object.updated_at) do
        object.image = open(object.image_url)
        object.image_file_name = URI.decode File.basename(object.image_url)
        object.save!
      end
      bar.increment!
    end
  end

  def objects
    Item.where("image_url IS NOT NULL").where(:image_file_name => nil)
  end
end

desc 'migrate items in innorganizations and people'
task :migrate_items => :environment do
  ItemsMigrator.new.migrate
end
