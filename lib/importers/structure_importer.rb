# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'sanitize'
require Rails.root.join 'app/models/subdivision'

class String
  def extract_phones
    res = []
    self.gsub(/\./, '').scan(/(телефон|тел\/факс|тел|факс):? ((?:(?:(?:(?:8 )?\((?:[\d-]+)\) )?[\d-]+)(?:, )?)+)/i).each do |kind, numbers|
      kind = kind.mb_chars.capitalize.to_s
      kind = "Телефон" if kind == "Тел"
      kind = "Тел./факс" if kind == "Тел/факс"
      kind = Phone.human_enums[:kind].invert[kind]
      numbers.split(/, /).each do |code_number|
        code, number = code_number.match(/(?:(?:8 )?\(([\d-]+)\) )?([\d-]+)/)[1..2]
        code ||= '3822'
        code.gsub! /-/, ''
        res << {:kind => kind, :number => number, :code => code }
      end
    end
    res
  end

  def extract_emails
    self.split(/,? /).map{|address| { :address => address }}
  end

  def extract_url
    self.match(/(http:[^\s]+)/).try(:[], 1)
  end

  def extract_address
    self.gsub!(/Адрес: г.Томск/, "Адрес: 634000, г.Томск")
    postcode, locality, street, house, building_no = self.match(/(?:Адрес(?: расположения)?: )?(?:(\d{6}), (г. ?Томск), (.*?), ([^ ,\n]+))/).try :[], 1..4
    {:postcode => postcode,
    :locality => locality.try(:gsub, /г.Томск/, "г. Томск"),
    :street => street,
    :house => house,
    :building => building_no}
  end
end

class Subdivision
  attr_accessor :import_url
  attr_accessor :html

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

  def import_info(info)
    update_attributes! :url => info.extract_url,
                       :phones_attributes => info.extract_phones,
                       :emails_attributes => (info.match(/mail:[[:space:]]*([^[:space:],]+)/m).try(:[], 1).try(:extract_emails) || []),
                       :address_attributes => info.extract_address
  end

  def import
    begin
      import_info(subdivision_text)
      import_items
    rescue => e
      puts "#{e.message} во время импорта #{import_url}"
      throw e
    end
  end

  def import_items
    subdivision = self
    items_table.css('tr')[1..-1].each do | tr |
      texts = tr.css("td,th").map &:text
      tds = texts.map{|text| text.gsub(/[[:space:]]+/, ' ').squish }
      if tds.count > 1
        surname, name, patronymic = tds[0].to_s.split
        phones = tds[phone_column].to_s.extract_phones
        if phones.empty?
          phones = tds[phone_column].to_s.gsub(/ ?- ?/, '-').scan(/([\d-]+)/).flatten.map{|number| {:kind => :phone, :number => number}}
        end
        subdivision.items.find_or_initialize_by_title(tds[1]).tap do | item |
          item.update_attributes! :person_attributes => {:surname => surname, :name => name, :patronymic => patronymic},
                                  :address_attributes => subdivision.address_attributes.merge(:office => tds[office_column], :id => nil),
                                  :phones_attributes => phones,
                                  :emails_attributes => tds[email_column].to_s.extract_emails
        end
      else
        content = texts.first
        title = content.split('\n').first
        subdivision = children.find_or_initialize_by_title(title).tap do | subdivision |
          subdivision.address_attributes = self.address_attributes.merge(:id => nil)
          subdivision.import_info(content)
        end
      end
    end
  end

  def email_column
    @email_column ||= header_column_index('mail')
  end

  def office_column
    @office_column ||= header_column_index('кабинет', 'каб.')
  end

  def phone_column
    @phone_column ||= header_column_index('телефон', 'тел.')
  end

  def header_column_index(*values)
    header_columns.each_with_index do | value, index |
      return index if value =~ /(#{values.join('|').gsub(/\./, '\.')})/i
    end
    1000
  end

  def header_columns
    @header_columns ||= header_row.css('td,th').map{|column| column.text.squish }
  end

  def header_row
    @header_row ||= items_table.css('tr').first
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
    @html ||= open(import_url).tap { print "." }
  end

end

class StructureImporter

  def import
    import_roots
    import_subdivisions
    puts unless Rails.env.test?
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
    @html ||= open('http://tomsk.gov.ru/ru/rule/structure/').tap { print "." }
  end

  def import_roots
    Subdivision.create_governor
    Subdivision.create_administration
  end

end

