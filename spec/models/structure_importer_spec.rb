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

    describe "при импорте подразделений" do
      let(:green_tsu_ru) { Fabricate :subdivision }
      before do
        green_tsu_ru.should_receive(:html).and_return File.read(Rails.root.join("spec/fixtures/green_tsu_ru.html"))
        green_tsu_ru.import
      end
      it { green_tsu_ru.building.to_s.should == "634034, Томская область, г. Томск, пр. Кирова, 14"}
      it { green_tsu_ru.phones(true).map(&:kind).should == %w[phone fax] }
      it { green_tsu_ru.emails(true).map(&:address).should == %w[sec@green.tsu.ru] }
      it { green_tsu_ru.url.should == 'http://green.tsu.ru/' }
      it { green_tsu_ru.items.count.should == 9 }
      it { green_tsu_ru.items.second.emails.map(&:address).should == ["sec@green.tsu.ru"] }
      it { green_tsu_ru.items.second.phones.map(&:number).should == ["56-36-58", "56-36-46"] }
      it { green_tsu_ru.items.second.phones.map(&:kind).should == ["phone", "fax"] }
      it { green_tsu_ru.items(true).last.phones.map(&:kind).should == ["phone", "phone"] }
      it { green_tsu_ru.items(true).last.phones.map(&:number).should == ["303-359", "8-913-823-25-89"] }
    end

  end

end
