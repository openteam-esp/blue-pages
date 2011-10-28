# encoding: utf-8

require 'spec_helper'

describe AdminAbility do
  let(:root)                  { Category.root }
  let(:child_1)               { root.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child_1_1)             { child_1.subdivisions.create Fabricate.attributes_for(:subdivision) }
  let(:child_2)               { root.subdivisions.create Fabricate.attributes_for(:subdivision) }

  def ability_for(user)
    AdminAbility.new(user)
  end

  def user
    Fabricate(:admin_user)
  end

  def admin_of(category)
    user.tap do | user |
      user.categories << category
    end
  end

  describe 'администратор телефонного справочника' do
    let(:ability) { ability_for(admin_of(root)) }

    describe 'управление подразделениями' do
      it { ability.should be_able_to(:manage, root) }
      it { ability.should be_able_to(:manage, child_1) }
      it { ability.should be_able_to(:manage, child_1_1) }
      it { ability.should be_able_to(:manage, child_2) }
    end

    describe 'управление пользователями' do
      it { ability.should be_able_to(:manage, user) }
      it { ability.should be_able_to(:update, admin_of(root)) }
      it { ability.should be_able_to(:update, admin_of(child_1)) }
      it { ability.should be_able_to(:update, admin_of(child_1_1)) }
      it { ability.should be_able_to(:update, admin_of(child_2)) }
    end

    describe 'управление должностями' do
      it { ability.should be_able_to(:manage, child_1.items.new) }
      it { ability.should be_able_to(:manage, child_1_1.items.new) }
      it { ability.should be_able_to(:manage, child_2.items.new) }
    end
  end

  describe 'администратор вложенного подразделения' do
    let(:ability) { ability_for(admin_of(child_1)) }

    describe 'управление подразделениями' do
      it { ability.should_not be_able_to(:manage, root) }
      it { ability.should be_able_to(:manage, child_1) }
      it { ability.should be_able_to(:manage, child_1_1) }
      it { ability.should_not be_able_to(:manage, child_2) }
    end

    describe 'управление пользователями' do
      it { ability.should_not be_able_to(:manage, user) }
      it { ability.should_not be_able_to(:update, admin_of(root)) }
      it { ability.should be_able_to(:update, admin_of(child_1)) }
      it { ability.should be_able_to(:update, admin_of(child_1_1)) }
      it { ability.should_not be_able_to(:update, admin_of(child_2)) }
    end

    describe 'управление должностями' do
      it { ability.should be_able_to(:manage, child_1.items.new) }
      it { ability.should be_able_to(:manage, child_1_1.items.new) }
      it { ability.should_not be_able_to(:manage, child_2.items.new) }
    end
  end
end
