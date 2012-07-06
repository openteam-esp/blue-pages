# encoding: utf-8
require 'csv'

class CompanyImporter
  def get_records
    csv_data = CSV.read(Rails.root.join('stuff/companies.csv'), :encoding => 'UTF-8')
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end

  def records
    @records_array ||= get_records
  end

  def import
    records.each do |record|
      title = record['title'].gsub(/"\b/,'«').gsub(/\b"/,'»').squish
      Category.find_by_kind('innorganizations').innorganizations.find_or_initialize_by_title(title).tap do |innorganization|
        innorganization.url = record['site']

        status = []
        status << 'sez' if record['status'] =~ /резидент ОЭЗ/
        status << 'skolkovo' if record['status'] =~ /резидент Сколково/
        status << 'innovation_company' if record['status'] =~ /(инновационная компания)|(МИП)/
        status << 'business-incubator' if record['status'] =~ /инкубатор/
        innorganization.status = status

        sphere = []
        sphere << 'it' if record['sphere'] =~ /it/i
        sphere << 'medicine' if record['sphere'] =~ /медицин/i
        sphere << 'energy' if record['sphere'] =~ /энерго/i
        sphere << 'chemistry' if record['sphere'] =~ /химия/i
        sphere << 'nanotechnologies' if record['sphere'] =~ /нано/i
        sphere << 'building' if record['sphere'] =~ /строительство/i
        sphere << 'ecology' if record['sphere'] =~ /экология/i
        sphere << 'safety' if record['sphere'] =~ /безопасность/i
        sphere << 'other' if record['sphere'] =~ /другое/i
        innorganization.sphere = sphere

        innorganization.production = record['production']

        postcode = record['address'].match(/\d{6}/)
        postcode = postcode ? postcode[0].to_i : 634000
        if record['address'].match(/Юрга/i)
          postcode = '652050'
        end
        city = record['address'].match(/[гс]\.\s[[:alnum:]]+/)
        city = city[0].squish if city

        if city == 'г. Кемерово'
          district = 'г. Кемерово'
          region = 'Кемеровская область'
          postcode = 650000
        end

        if city == 'г. Юрга'
          district = 'Юргинский район'
          region = 'Кемеровская область'
        end

        if ['г. Северск', 'г. Томск'].include?(city)
          district = 'г. Томск'
          region = 'Томская область'
        end

        if ['с. Рыбалово', 'с. Кафтанчиково'].include?(city)
          district = 'Томский район'
          region = 'Томская область'
        end

        if record['address'].present?
          street, house, office = record['address'].match(/(?:[гс]\.\s[[:alnum:]]+,\s)((?:[[:alpha:]]{2,3}\.\s)?(?:[[:alnum:]]+\s?)+)(?:,\sд\.\s([[:alnum:]\/]+))?(?:(?:,\s(?:оф|кв)\.\s)([[:alnum:]]+))?/)[1..-1]
          innorganization.build_address(:postcode => postcode, :locality => city, :district => district, :region => region, :street => street, :house => house, :office => office)
        end

        if record['email'].present?
          email = record['email'].squish
          innorganization.emails.find_or_initialize_by_address(:address => email)
        end

        if record['contacts'].present?
          record['contacts'].scan(/([[:alpha:]]+\.?(?:\/[[:alpha:]]+)?)\s(?:\(([[:digit:]]+)\)\s)?([[:digit:]-]+)(?:\sдоп\.\s([[:digit:]]+))?/).each do |contact|
            type, code, phone, addit = contact
            if type == 'тел.'
              type = 'phone'
            end
            if type == 'факс'
              type = 'fax'
            end
            if type == 'тел./факс'
              type = 'phone_and_fax'
            end
            if type == 'моб.'
              type = 'mobile'
            end
            innorganization.phones.find_or_initialize_by_number(phone).tap do |phone|
              phone.kind = type
              phone.code = code unless type == 'mobile'
              phone.additional_number = addit
            end
          end
        end

        innorganization.save!

        if record['chief'].present?
          patronymic, name, surname, chief_title = record['chief'].scan(/(?:((?:[[:alpha:]]+\s?)+)?,\s)?([[:alpha:]]+)/).flatten.compact.reverse
          chief_title = chief_title ? chief_title : 'Директор'
          innorganization.create_chief(:title => chief_title, :person_attributes => {:name => name, :surname => surname, :patronymic => patronymic}) unless innorganization.chief
        end

        if record['description'].present? || record['more'].present?
          desc = ''
          desc << record['description']
          desc << record['more']
        end

        p title
      end
    end
  end
end

desc 'Импорт компаний'
task :import_companies => :environment do
  CompanyImporter.new.import
end

