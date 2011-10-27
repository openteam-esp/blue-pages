# encoding: utf-8

require 'spec_helper'

describe AdminAbility do
  # root1_subdivision      (managed by user)
  #   one_subdivision
  #   two_subdivision      (managed by anoter_user and one_more_another_user)
  #     child1_subdivision
  #     child2_subdivision
  # root2_subdivision      (managed by one_more_another_user)

  let(:root1_subdivision)     { Fabricate(:subdivision) }
  let(:one_subdivision)       { root1_subdivision.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:two_subdivision)       { root1_subdivision.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child1_subdivision)    { two_subdivision.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child2_subdivision)    { two_subdivision.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:root2_subdivision)     { Fabricate(:subdivision) }

  let(:user)                  { Fabricate(:admin_user) }
  let(:another_user)          { Fabricate(:admin_user) }
  let(:one_more_another_user) { Fabricate(:admin_user) }

  def ability_for(user)
    AdminAbility.new(user)
  end

  before { user.subdivisions << root1_subdivision }

  describe 'управление подразделениями' do
    describe 'пользователь' do
      describe 'может' do
        it { ability_for(user).should be_able_to(:manage, root1_subdivision) }

        it { ability_for(user).should be_able_to(:manage, one_subdivision) }
        it { ability_for(user).should be_able_to(:manage, one_subdivision.items.new) }

        it { ability_for(user).should be_able_to(:manage, child1_subdivision) }
        it { ability_for(user).should be_able_to(:manage, child1_subdivision.items.new) }
      end

      describe 'не может' do
        it { ability_for(user).should_not be_able_to(:manage, root2_subdivision) }
      end
    end
  end

  describe 'управление пользователями' do
    before do
      another_user.subdivisions << two_subdivision
      one_more_another_user.subdivisions << two_subdivision
      one_more_another_user.subdivisions << root2_subdivision
      child1_subdivision
      child2_subdivision
    end

    xit { ability_for(user).should be_able_to(:update, another_user) }
    xit { ability_for(user).should be_able_to(:update, one_more_another_user) }

    xit { ability_for(another_user).should be_able_to(:update, one_more_another_user) }
    xit { ability_for(another_user).should_not be_able_to(:update, user) }

    xit { ability_for(one_more_another_user).should_not be_able_to(:update, user) }
  end
end
