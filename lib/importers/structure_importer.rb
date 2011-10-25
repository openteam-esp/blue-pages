# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'sanitize'
require Rails.root.join 'app/models/subdivision'

class Subdivision
  attr_accessor :import_url

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


  def import
    postcode, locality, street, house, building_no = text.match(/Адрес(?: расположения)?: (?:(\d{6}), (г. ?Томск), (.*?), ([^ ,]+))/).try :[], 1..4
    text.scan(/(телефон|факс): 8 \((\d+)\) ([\d-]+)/i).each do | kind, code, number |
      kind = Phone.human_enums[:kind].invert[kind.mb_chars.capitalize.to_s]
      phones.find_or_initialize_by_number(number).tap do |phone|
        phone.update_attributes(:code => code, :kind => kind)
      end
    end
    phones(true)

    if address = text.match(/mail:[[:space:]]*([^[:space:],]+)/m)[1]
      emails.find_or_create_by_address(address)
    end

    update_attribute :url, text.match(/(http:[^ ]+)/)[1]

    build_building unless building

    building.update_attributes(:postcode => postcode,
                               :locality => locality.gsub(/г.Томск/, "г. Томск"),
                               :street => street,
                               :house => house,
                               :building => building_no)

    import_items
  end

  def import_items
    content_second.css('table tr')[1..-1].each do | tr |
      tds = tr.css("td").map{|td| td.text.gsub(/[[:space:]]+/, ' ').squish }
      surname, name, patronymic = tds[0].split
      items.find_or_initialize_by_title(tds[1]).tap do | item |
        item.update_attributes :person_attributes => {:surname => surname, :name => name, :patronymic => patronymic},
                               :office => tds[2],
                               :phones_attributes => phones_attributes(tds[3]),
                               :emails_attributes => tds[4].split(/,? /).map{|address| { :address => address }}
      end

    end
  end

  def phones_attributes(phone_string)
    res = []
    phone_string.scan(/(тел|факс)\. ((?:(?:[\d-]+)(?:, )?)+)/).each do |kind, numbers|
      kind = (kind == "тел" ? "phone" : "fax")
      numbers.split(/, /).each do |number|
        res << {:kind => kind, :number => number }
      end
    end
    res
  end

  def text
    @text ||= Sanitize.clean(content_second.to_s)
  end

  def content_second
    @content_second ||= Nokogiri::HTML(html).css('.content-second').first
  end

  def html
    @html ||= open(import_url)
  end

end

class StructureImporter

  def import
    import_roots
    import_subdivisions
  end

  def import_subdivisions
    doc = Nokogiri::HTML(open('http://tomsk.gov.ru/ru/rule/structure/'))
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
          subdivision.import_url = "http://tomsk.gov.ru#{a.attributes['href'].value}"
          subdivision.import
        end
      end
    end
  end

  def import_roots
    Subdivision.create_governor
    Subdivision.create_administration
  end

end

