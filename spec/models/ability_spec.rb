# encoding: utf-8

require 'spec_helper'

describe Ability do
  describe 'пользователь' do
    let(:subdivision) { Fabricate(:subdivision) }
    let(:child_subdivision) { subdivision.children.create(Fabricate.attributes_for(:subdivision)) }
    let(:user) { Fabricate(:admin_user) }
    let(:ability) { Ability.new(user) }

    describe do 'может'
      before do
        user.subdivisions << subdivision
      end

      it { ability.should be_able_to(:manage, subdivision) }
      it { ability.should be_able_to(:manage, child_subdivision) }
    end

    describe 'не может' do
      it { ability.should_not be_able_to(:manage, subdivision) }
    end
  end
end
