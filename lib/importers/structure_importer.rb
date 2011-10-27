# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'sanitize'
require Rails.root.join 'app/models/subdivision'

class String
  def lines
    self.split("\n")
  end

  def extract_phones
    res = []
    self.gsub(/\./, '').scan(/(телефон|тел\/факс|тел|факс|внутр|внутренний):?(?: -)? ((?:(?:(?:(?:8 )?\((?:[ \d-]+)\) )?[\d-]+)(?:, )?)+)/i).each do |kind, numbers|
      kind = kind.mb_chars.capitalize.to_s
      kind = "Телефон" if kind == "Тел"
      kind = "Внутренний" if kind == "Внутр"
      kind = "Тел./факс" if kind == "Тел/факс"
      kind = Phone.human_enums[:kind].invert[kind]
      numbers.split(/, /).each do |code_number|
        code, number = code_number.match(/(?:(?:8 )?\(([\d-]+)\) )?([\d-]+)/)[1..2]
        code ||= '3822'
        code.gsub! /[^\d]/, ''
        res << {:kind => kind, :number => number, :code => code }
      end
    end
    res
  end

  def extract_emails
    lines.each do | line |
      if line =~ /@/
        return line.split(/,? /).grep(/@/).map{|address| { :address => address }}
      end
    end
    []
  end

  def extract_url
    lines.each do | line |
      if line =~ /http/
        return line.match(/(http:[^\s]+)/).try(:[], 1)
      end
    end
    nil
  end

  def extract_address
    postcode, locality, street, house, building_no = nil
    self.gsub!(/Адрес: г. ?Томск/, "Адрес: 634000, г.Томск")
    self.split("\n").each do | line |
      if address_match = line.match(/(?:Адрес(?: расположения)?: )?(?:(\d{6}), (г. ?Томск), (.*?), ([^ ,]+))/)
        postcode, locality, street, house, building_no = address_match[1..4]
        break
      end
    end
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
    Subdivision.find_or_initialize_by_title('Губернатор').tap do | governor |
      governor.update_attributes :position => 1,
                                 :address_attributes => { :postcode => '634050', :street => 'пл. Ленина', :house => '6' }
    end
  end

  def self.administration
    Subdivision.find_or_initialize_by_title('Администрация').tap do | administration |
      administration.update_attribute :position, 2
    end
  end

  def import_info(info)
    update_attributes :url => info.extract_url,
                      :phones_attributes => info.extract_phones,
                      :emails_attributes => (info.match(/mail:[[:space:]]*([^[:space:],]+)/m).try(:[], 1).try(:extract_emails) || []),
                      :address_attributes => info.extract_address

    unless valid?
      p info.extract_phones
      p info.extract_emails
      p info.extract_address
      p self
      save!
    end
  end

  def import_assistent
    items.find_or_initialize_by_title(title).tap do | item |
      item.update_attributes :person_attributes => { :full_name => page.css('h1:first').first.text.squish },
                             :phones_attributes => self.phones.map{|phone| phone.attributes.merge(:id => nil) },
                             :address_attributes => self.address_attributes.merge(:id => nil),
                             :emails_attributes => self.emails.map{|email| email.attributes.merge(:id => nil) },
    end
  end

  def import
    begin
      unless Rails.env.test?
        puts "================================="
        puts import_url
      end
      import_info(subdivision_text)
      items.destroy_all
      if parent == Subdivision.governor || self == Subdivision.governor
        import_assistent
      end
      import_items
    rescue => e
      puts e.backtrace.grep(/structure_importer/).first#.join("\n")
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
        subdivision.items.create(:title => tds[1]).tap do | item |
          item.update_attributes :person_attributes => {:surname => surname, :name => name, :patronymic => patronymic},
                                 :address_attributes => subdivision.address_attributes.merge(:office => tds[office_column], :id => nil),
                                 :phones_attributes => phones,
                                 :emails_attributes => tds[email_column].to_s.extract_emails
          unless item.valid?
            p phones
            p tds[email_column].to_s.extract_emails
            p subdivision.address_attributes.merge(:office => tds[office_column], :id => nil)
            p item
            item.save!
          end
        end
      else
        content = texts.first.strip
        lines = content.split("\n").map{|line| line.gsub(/[[:space:]]/, ' ').squish }
        title = lines.first.gsub(/“/, '"').gsub(/”/, '"')
        subdivision = children.find_or_initialize_by_title(title).tap do | subdivision |
          subdivision.address_attributes = self.address_attributes.merge(:id => nil)
          subdivision.import_info(lines[1..-1].join("\n"))
          subdivision.items.destroy_all
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
    @html ||= open(import_url)
  end

end

class StructureImporter

  def import
    import_subdivisions
  end

  def import_subdivisions
    Nokogiri::HTML(html).css('.content-second a[href*="/ru/rule/structure"]').each do |a|
      title = Sanitize.clean(a.text).squish
      href = a.attributes['href'].value
      next if title.blank? || href =~ /.doc$/
      case title
      when /^губернатор/i
        subdivision = Subdivision.governor
      when /заместитель/i
        subdivision = Subdivision.governor.children.find_or_initialize_by_title(title)
        subdivision.update_attributes :address_attributes => Subdivision.governor.address_attributes.merge(:id => nil)
      else
        subdivision = Subdivision.administration.children.find_or_initialize_by_title(title)
      end
      subdivision.save!
      subdivision.import_url = "http://tomsk.gov.ru#{a.attributes['href'].value}"
      subdivision.import
    end
  end

  def html
    @html ||= open('http://tomsk.gov.ru/ru/rule/structure/')
  end

end

