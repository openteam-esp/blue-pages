# encoding: utf-8

require 'spec_helper'

require Rails.root.join "lib/importers/structure_importer"

describe StructureImporter do

  describe "#import_roots" do

    describe "должен импортировать структуру" do
      before do
        Subdivision.any_instance.stub(:import)
        subject.should_receive(:html).and_return File.read(Rails.root.join("spec/fixtures/structure.html"))
        subject.import
      end
      it { Subdivision.roots.map(&:title).should == ["Губернатор", "Администрация"] }
      it { Subdivision.governor.children.count.should == 11 }
      it { Subdivision.administration.children.count.should == 48 }
    end

    let(:subdivision) { Fabricate :subdivision }

    def import(subdivision_name)
      subdivision.html = File.read(Rails.root.join("spec/fixtures/#{subdivision_name}.html"))
      subdivision.import
    end

    describe "при импорте подразделений" do
      before { import :department_natural_resources }
      it { subdivision.address.to_s.should == "634034, Томская область, г. Томск, пр. Кирова, 14"}
      it { subdivision.phones(true).map(&:kind).should == %w[phone fax] }
      it { subdivision.emails(true).map(&:address).should == %w[sec@green.tsu.ru] }
      it { subdivision.url.should == 'http://green.tsu.ru/' }
      it { subdivision.items.count.should == 9 }
      it { subdivision.items.second.emails.map(&:address).should == ["sec@green.tsu.ru"] }
      it { subdivision.items.second.phones.map(&:number).should == ["56-36-58", "56-36-46"] }
      it { subdivision.items.second.phones.map(&:kind).should == ["phone", "fax"] }
      it { subdivision.items(true).last.phones.map(&:kind).should == ["phone", "phone"] }
      it { subdivision.items(true).last.phones.map(&:number).should == ["303-359", "8-913-823-25-89"] }
    end

    describe "импорт вложенных подразделений" do
      before { import :government_archival }
      it { subdivision.address.to_s.should == "634009, Томская область, г. Томск, ул. К.Маркса, 26"}
      it { subdivision.phones(true).map(&:kind).should == %w[phone fax] }
      it { subdivision.phones(true).map(&:number).should == %w[515-723 510-377] }
      it { subdivision.emails(true).map(&:address).should == %w[oblarch@tomsk.gov.ru] }
      it { subdivision.url.should == 'http://archupr.tomsk.gov.ru/' }
      it { subdivision.items.count.should == 7 }
      it { subdivision.children.count.should == 5 }
      it { subdivision.items.second.emails.map(&:address).should == ["oblarch@tomsk.gov.ru"] }
      it { subdivision.items.second.phones.map(&:number).should == ["515-723"] }
      it { subdivision.items.second.phones.map(&:kind).should == ["phone"] }
      it { subdivision.items(true).last.phones.map(&:to_s).should == ["Тел./факс: (3822) 511-560"] }

      describe ', вложенное подразделение должно' do
        let (:subsubdivision) { subdivision.children.second }

        it { subsubdivision.url.should == 'http://www.gato.tomica.ru/' }
        it { subsubdivision.emails.map(&:address).should == ['awbgat@mail.tomsknet.ru'] }
        it { subsubdivision.phones.map(&:to_s).should == ['Тел./факс: (3822) 513-025'] }
        it { subsubdivision.address.to_s.should == '634009, Томская область, г. Томск, ул. К.Маркса, 26' }
        it { subsubdivision.items.count.should == 6 }
      end
    end

    describe 'импорт из странички с нестандартным расположением колонок' do
      before { import :department_families }
      it { subdivision.items.first.phones.map(&:to_s).should == ["Телефон: (3822) 71-39-98"] }
      it { subdivision.items.first.address(true).to_s.should include "г. Томск, ул.Тверская, 74, 301" }
      it { subdivision.address.to_s.should include "г. Томск, ул.Тверская, 74" }
      it { subdivision.children.first.items.first.emails.map(&:address).should == %w[sma@family.tomsk.gov.ru] }
      it { subdivision.children.first.items.first.address(true).office.should == "308" }
    end
  end
end
