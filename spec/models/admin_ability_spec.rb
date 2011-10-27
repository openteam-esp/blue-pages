# encoding: utf-8

require 'spec_helper'

describe AdminAbility do
  # root      (managed by user)
  #   child_1
  #   child_2      (managed by anoter_user and one_more_another_user)
  #     child_2_1
  #     child_2_2
  # another_root      (managed by one_more_another_user)

  let(:root)                  { Fabricate(:category) }
  let(:child_1)               { root.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child_2)               { root.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child_2_1)             { child_2.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child_2_2)             { child_2.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:another_root)          { Fabricate(:category) }

  let(:user)                  { Fabricate(:admin_user) }
  let(:another_user)          { Fabricate(:admin_user) }
  let(:one_more_another_user) { Fabricate(:admin_user) }

  def ability_for(user)
    AdminAbility.new(user)
  end

  before { user.categories << root }

  describe 'управление подразделениями' do
    describe 'пользователь' do
      describe 'может' do
        it { ability_for(user).should be_able_to(:manage, root) }

        it { ability_for(user).should be_able_to(:manage, child_1) }
        it { ability_for(user).should be_able_to(:manage, child_1.items.new) }

        it { ability_for(user).should be_able_to(:manage, child_2_1) }
        it { ability_for(user).should be_able_to(:manage, child_2_1.items.new) }
      end

      describe 'не может' do
        it { ability_for(user).should_not be_able_to(:manage, another_root) }
      end
    end
  end

  describe 'управление пользователями' do
    before do
      another_user.categories << child_2
      one_more_another_user.categories << child_2
      one_more_another_user.categories << another_root
      child_2_1
      child_2_2
    end

    xit { ability_for(user).should be_able_to(:update, another_user) }
    xit { ability_for(user).should be_able_to(:update, one_more_another_user) }

    xit { ability_for(another_user).should be_able_to(:update, one_more_another_user) }
    xit { ability_for(another_user).should_not be_able_to(:update, user) }

    xit { ability_for(one_more_another_user).should_not be_able_to(:update, user) }
  end
end
