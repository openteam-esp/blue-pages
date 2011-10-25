# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'sanitize'
require Rails.root.join 'app/models/subdivision'

class Subdivision
  def self.governor
    @governor ||= create_governor
  end

  def self.create_governor
    Subdivision.find_or_initialize_by_title('Губернатор').tap do | governor |
      governor.update_attribute :position, 1
    end
  end

  def self.administration
    @administration ||= create_administration
  end

  def self.create_administration
      Subdivision.find_or_initialize_by_title('Администрация').tap do | administration |
      administration.update_attribute :position, 2
    end
  end
end

class StructureImporter

  def import
    import_roots
    import_subdivisions
  end

  def import_subdivisions
    doc = Nokogiri::HTML(open(Rails.root.join 'spec/fixtures/structure.html'))
    doc.css('.content-second a[href*="/ru/rule/structure"]').each do |a|
      title = Sanitize.clean(a.text).squish
      next if title.blank?
      if title =~ /заместитель/i
        Subdivision.governor.children.find_or_initialize_by_title(title).tap do | subdivision |
          subdivision.save!
        end
      else
        next if title =~ /^губернатор/i
        Subdivision.administration.children.find_or_initialize_by_title(title).tap do | subdivision |
          subdivision.save!
        end
      end
    end
  end

  def import_roots
    Subdivision.create_governor
    Subdivision.create_administration
  end

end

