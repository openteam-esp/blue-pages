# encoding: utf-8

require 'spec_helper'

require Rails.root.join "lib/importers/structure_importer"

describe StructureImporter do

  describe "#import_roots" do

    describe "должен импортировать структуру" do
      before do
        Subdivision.any_instance.stub(:import)
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
    end

  end

end
