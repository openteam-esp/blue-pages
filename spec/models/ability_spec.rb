# encoding: utf-8

require 'spec_helper'

describe Ability do
  let(:root)                { Category.root }
    let(:child_1)           { Fabricate :subdivision }
      let(:category_1_1)    { Fabricate :category, :parent => child_1 }
    let(:child_1_1)         { Fabricate :subdivision, :parent => child_1 }
    let(:child_2)           { Fabricate :subdivision }

  def ability_for(user)
    Ability.new(user)
  end

  def user
    Fabricate(:user)
  end

  %w[manager editor operator].each do | role |
    define_method "#{role}_of" do | category |
      user.tap do | user |
        user.permissions.create! :context => category, :role => role
      end
    end
  end

  context 'менеджер' do
    context 'телефонного справочника' do
      subject { ability_for(manager_of(root)) }

      context 'управление пользователями' do
        it { should be_able_to(:manage, user) }
        it { should be_able_to(:manage, manager_of(root)) }
        it { should be_able_to(:manage, manager_of(child_1)) }
        it { should be_able_to(:manage, manager_of(child_1_1)) }
        it { should be_able_to(:manage, manager_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should be_able_to(:create, user.permissions.new) }
        it { should be_able_to(:manage, manager_of(root).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should be_able_to(:modify, child_2) }
      end

      context 'управление должностями' do
        it { should be_able_to(:modify, child_1.items.new) }
        it { should be_able_to(:modify, child_1_1.items.new) }
        it { should be_able_to(:modify, child_2.items.new) }
      end
    end

    context 'вложенного подразделения' do
      subject { ability_for(manager_of(child_1)) }

      context 'управление пользователями' do
        it { should be_able_to(:manage, user) }
        it { should be_able_to(:manage, editor_of(root)) }
        it { should be_able_to(:manage, editor_of(child_1)) }
        it { should be_able_to(:manage, editor_of(child_1_1)) }
        it { should be_able_to(:manage, editor_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should be_able_to(:create, user.permissions.new) }
        it { should_not be_able_to(:manage, manager_of(root).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should_not be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should_not be_able_to(:modify, child_2) }
      end

      context 'управление должностями' do
        it { should be_able_to(:modify, child_1.items.new) }
        it { should be_able_to(:modify, child_1_1.items.new) }
        it { should_not be_able_to(:modify, child_2.items.new) }
      end
    end
  end

  context 'редактор' do
    context 'телефонного справочника' do
      subject { ability_for(editor_of(root)) }

      context 'управление пользователями' do
        it { should_not be_able_to(:manage, user) }
        it { should_not be_able_to(:manage, editor_of(root)) }
        it { should_not be_able_to(:manage, editor_of(child_1)) }
        it { should_not be_able_to(:manage, editor_of(child_1_1)) }
        it { should_not be_able_to(:manage, editor_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:create, user.permissions.new) }
        it { should_not be_able_to(:manage, manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should be_able_to(:modify, child_2) }
      end

      context 'управление должностями' do
        it { should be_able_to(:modify, child_1.items.new) }
        it { should be_able_to(:modify, child_1_1.items.new) }
        it { should be_able_to(:modify, child_2.items.new) }
      end

      context 'управление досье' do
        it { should be_able_to(:modify_dossier, child_1) }
        it { should be_able_to(:modify_dossier, child_1.items.new) }
        it { should be_able_to(:modify_dossier, child_1_1) }
        it { should be_able_to(:modify_dossier, child_1_1.items.new) }
        it { should be_able_to(:modify_dossier, child_2) }
        it { should be_able_to(:modify_dossier, child_2.items.new) }
      end
    end

    context 'вложенного подразделения' do
      subject { ability_for(editor_of(child_1)) }

      context 'управление пользователями' do
        it { should_not be_able_to(:manage, user) }
        it { should_not be_able_to(:manage, editor_of(root)) }
        it { should_not be_able_to(:manage, editor_of(child_1)) }
        it { should_not be_able_to(:manage, editor_of(child_1_1)) }
        it { should_not be_able_to(:manage, editor_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:create, user.permissions.new) }
        it { should_not be_able_to(:manage, manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should_not be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should_not be_able_to(:modify, child_2) }
      end

      context 'управление должностями' do
        it { should be_able_to(:modify, child_1.items.new) }
        it { should be_able_to(:modify, child_1_1.items.new) }
        it { should_not be_able_to(:modify, child_2.items.new) }
      end

      context 'управление досье' do
        it { should be_able_to(:modify_dossier, child_1) }
        it { should be_able_to(:modify_dossier, child_1.items.new) }
        it { should be_able_to(:modify_dossier, child_1_1) }
        it { should be_able_to(:modify_dossier, child_1_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_2) }
        it { should_not be_able_to(:modify_dossier, child_2.items.new) }
      end
    end
  end

  context 'оператор' do
    context 'телефонного справочника' do
      subject { ability_for(operator_of(root)) }

      context 'управление пользователями' do
        it { should_not be_able_to(:manage, user) }
        it { should_not be_able_to(:manage, editor_of(root)) }
        it { should_not be_able_to(:manage, editor_of(child_1)) }
        it { should_not be_able_to(:manage, editor_of(child_1_1)) }
        it { should_not be_able_to(:manage, editor_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:create, user.permissions.new) }
        it { should_not be_able_to(:manage, manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should be_able_to(:modify, child_2) }
      end

      context 'управление должностями' do
        it { should be_able_to(:modify, child_1.items.new) }
        it { should be_able_to(:modify, child_1_1.items.new) }
        it { should be_able_to(:modify, child_2.items.new) }
      end

      context 'управление досье' do
        it { should_not be_able_to(:modify_dossier, child_1) }
        it { should_not be_able_to(:modify_dossier, child_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_1_1) }
        it { should_not be_able_to(:modify_dossier, child_1_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_2) }
        it { should_not be_able_to(:modify_dossier, child_2.items.new) }
      end
    end

    context 'вложенного подразделения' do
      subject { ability_for(operator_of(child_1)) }

      context 'управление пользователями' do
        it { should_not be_able_to(:manage, user) }
        it { should_not be_able_to(:manage, editor_of(root)) }
        it { should_not be_able_to(:manage, editor_of(child_1)) }
        it { should_not be_able_to(:manage, editor_of(child_1_1)) }
        it { should_not be_able_to(:manage, editor_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:create, user.permissions.new) }
        it { should_not be_able_to(:manage, manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should_not be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should_not be_able_to(:modify, child_2) }
      end

      context 'управление должностями' do
        it { should be_able_to(:modify, child_1.items.new) }
        it { should be_able_to(:modify, child_1_1.items.new) }
        it { should_not be_able_to(:modify, child_2.items.new) }
      end

      context 'управление досье' do
        it { should_not be_able_to(:modify_dossier, child_1) }
        it { should_not be_able_to(:modify_dossier, child_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_1_1) }
        it { should_not be_able_to(:modify_dossier, child_1_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_2) }
        it { should_not be_able_to(:modify_dossier, child_2.items.new) }
      end
    end
  end
end
