# encoding: utf-8

require 'spec_helper'

require Rails.root.join "lib/importers/structure_importer"

describe StructureImporter do

  describe "#import_roots" do

    before { subject.import }

    describe "должен импортировать" do
      it { Subdivision.roots.map(&:title).should == ["Губернатор", "Администрация"] }
      it { Subdivision.governor.children.count.should == 11 }
    end

  end

end
