# encoding: utf-8

require 'spec_helper'

require Rails.root.join "lib/importers/structure_importer"

describe StructureImporter do

  describe "#import" do

    describe "должен импортировать структуру" do
      before do
        Subdivision.any_instance.stub(:import)
        subject.should_receive(:html).and_return File.read(Rails.root.join("spec/fixtures/structure.html"))
        subject.import
      end
      it { Subdivision.governor.children.count.should == 11 }
      it { Subdivision.administration.children.count.should == 47 }
    end


    def child(number=0)
      subdivision.children[number]
    end

    def item(number=0)
      subdivision.items(true)[number]
    end

    def import(subdivision_name)
      subdivision.html = File.read(Rails.root.join("spec/fixtures/#{subdivision_name}.html"))
      subdivision.import
    end

    describe 'импорт подразделений' do
      let(:subdivision) { Fabricate :subdivision, :parent => Subdivision.administration }

      describe "импорт департмента натуральных ресурсов" do
        before { import :department_natural_resources }
        it { subdivision.address.to_s.should == "634034, Томская область, г. Томск, пр. Кирова, 14"}
        it { subdivision.phones(true).map(&:kind).should == %w[phone fax] }
        it { subdivision.emails(true).map(&:address).should == %w[sec@green.tsu.ru] }
        it { subdivision.url.should == 'http://green.tsu.ru/' }
        it { subdivision.items.count.should == 9 }
        it { item(1).emails.map(&:address).should == ["sec@green.tsu.ru"] }
        it { item(1).phones.map(&:number).should == ["56-36-58", "56-36-46"] }
        it { item(1).phones.map(&:kind).should == ["phone", "fax"] }
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
        it { item(1).emails.map(&:address).should == ["oblarch@tomsk.gov.ru"] }
        it { item(1).phones.map(&:number).should == ["515-723"] }
        it { item(1).phones.map(&:kind).should == ["phone"] }
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
        it { item.phones.map(&:to_s).should == ["Телефон: (3822) 71-39-98"] }
        it { item.address(true).full_address.should include "г. Томск, ул.Тверская, 74, кабинет 301" }
        it { subdivision.address.to_s.should include "г. Томск, ул.Тверская, 74" }
        it { child.items.first.emails.map(&:address).should == %w[sma@family.tomsk.gov.ru] }
        it { child.items.first.address(true).office.should == "308" }
      end

      describe 'департамент эволюции подвзятий' do
        before { import :department_evolution_undertakings }
        it { child(8).address.to_s.should == '634021, Томская область, г. Томск, ул. Шевченко, 17'}
      end
    end

    describe 'импорт заместителей' do
      let(:subdivision) do
        Subdivision.governor.subdivisions.create! :title => 'Заместитель губернатора Томской области по особо важным проектам'
      end
      before { import :assistant_special_orders }
      it { item.full_name.should == 'Точилин Сергей Борисович' }
      it { item.phones.map(&:to_s).should == ['Телефон: (3822) 511-142', 'Внутренний: 473']}
      it { item.address(true).full_address.should == '634050, Томская область, г. Томск, пл. Ленина, 6'}
      it { subdivision.items.count.should == 4 }
    end
    describe 'импорт губера' do
      let(:subdivision) { Subdivision.governor }
      before { import :governor }
      it { item.full_name.should == 'Кресс Виктор Мельхиорович' }
      it { item.phones.map(&:to_s).should == ['Телефон: (3822) 510-813', 'Телефон: (3822) 510-505']}
      it { item.address(true).full_address.should == '634050, Томская область, г. Томск, пл. Ленина, 6'}
      it { subdivision.items.count.should == 13 }
    end
  end
end
