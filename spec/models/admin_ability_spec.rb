# encoding: utf-8

require 'spec_helper'

describe AdminAbility do
  describe 'пользователь' do
    let(:root_subdivision) { Fabricate(:subdivision) }

    let(:subdivision) { root_subdivision.subdivisions.create Fabricate.attributes_for(:subdivision) }
    let(:child_subdivision) { subdivision.children.create(Fabricate.attributes_for(:subdivision)) }

    let(:user) { Fabricate(:admin_user) }
    let(:ability) { AdminAbility.new(user) }


    describe do 'может'
      before do
        user.subdivisions << root_subdivision
      end

      it { ability.should be_able_to(:manage, root_subdivision) }

      it { ability.should be_able_to(:manage, subdivision) }
      it { ability.should be_able_to(:manage, subdivision.items.new) }

      it { ability.should be_able_to(:manage, child_subdivision) }
      it { ability.should be_able_to(:manage, child_subdivision.items.new) }
    end

    describe 'не может' do
      it { ability.should_not be_able_to(:manage, subdivision) }
    end
  end
end
