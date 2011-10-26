# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'sanitize'
require Rails.root.join 'app/models/subdivision'

class String
  def extract_phones
    res = []
    self.scan(/(телефон|тел\.\/факс|тел|факс)\.?:? ((?:(?:(?:(?:8 )?\((?:[\d-]+)\) )?[\d-]+)(?:, )?)+)/i).each do |kind, numbers|
      kind = "телефон" if kind == "тел"
      kind = Phone.human_enums[:kind].invert[kind.mb_chars.capitalize.to_s]
      numbers.split(/, /).each do |code_number|
        code, number = code_number.match(/(?:(?:8 )?\(([\d-]+)\) )?([\d-]+)/)[1..2]
        code ||= '3822'
        code.gsub! /-/, ''
        res << {:kind => kind, :number => number, :code => code }
      end
    end
    res
    #scan(/(телефон|факс|тел\.):? (?:8 )?\(([\d-]+)\) ([\d-]+)/i).each do | kind, code, number |
      #kind = 'телефон' if kind == 'тел.'
      #kind = Phone.human_enums[:kind].invert[kind.mb_chars.capitalize.to_s]
      #phones.find_or_initialize_by_number(number).tap do |phone|
        #phone.update_attributes(:code => code.gsub(/-/, ""), :kind => kind)
      #end
    #end

  end
  def extract_emails
  end
  def extract_url
  end
  def extract_address
  end
end

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
    postcode, locality, street, house, building_no = subdivision_text.match(/Адрес(?: расположения)?: (?:(\d{6}), (г. ?Томск), (.*?), ([^ ,]+))/).try :[], 1..4

    if email_address = subdivision_text.match(/mail:[[:space:]]*([^[:space:],]+)/m).try(:[], 1)
      emails.find_or_create_by_address(email_address)
    end

    update_attributes :url => subdivision_text.match(/(http:[^ ]+)/).try(:[], 1),
                      :phones_attributes => subdivision_text.extract_phones

    build_address unless address

    address.update_attributes(:postcode => postcode,
                               :locality => locality.gsub(/г.Томск/, "г. Томск"),
                               :street => street,
                               :house => house,
                               :building => building_no)

    import_items
    puts unless Rails.env.test?
  end

  def import_items
     subdivision = self
     items_table.css('tr')[1..-1].each do | tr |
      tds = tr.css("td").map{|td| td.text.gsub(/[[:space:]]+/, ' ').squish }
      if tds.count == 5
        surname, name, patronymic = tds[0].split
        subdivision.items.find_or_initialize_by_title(tds[1]).tap do | item |
          item.update_attributes :person_attributes => {:surname => surname, :name => name, :patronymic => patronymic},
                                 :office => tds[2],
                                 :phones_attributes => tds[3].extract_phones,
                                 :emails_attributes => tds[4].split(/,? /).map{|address| { :address => address }}
        end
      else
        th = tr.css("th").first.text.strip
        title = th.split('\n').first
        subdivision = children.find_or_initialize_by_title(title).tap do | subdivision |
          subdivision.save
        end
      end
    end
  end

  def items_table
    page.css('table.border-bottom')
  end

  def subdivision_text
    @subdivision_text ||= Sanitize.clean(page.to_s[0..(page.to_s.index(items_table.to_s))])
  end

  def page
    @page ||= Nokogiri::HTML(html).css('.content-second').first
  end

  def html
    print "."
    @html ||= open(import_url)
  end

end

class StructureImporter

  def import
    import_roots
    import_subdivisions
  end

  def import_subdivisions
    Nokogiri::HTML(html).css('.content-second a[href*="/ru/rule/structure"]').each do |a|
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

  def html
    print "."
    @html ||= open('http://tomsk.gov.ru/ru/rule/structure/')
  end

  def import_roots
    Subdivision.create_governor
    Subdivision.create_administration
  end

end

