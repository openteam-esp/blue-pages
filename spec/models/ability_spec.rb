# encoding: utf-8

require 'spec_helper'

describe Ability do

  def root
    @root ||= Category.root
  end

  def create_context(parent=nil)
    Fabricate :subdivision, :parent => parent
  end

  context 'менеджер' do
    context 'корневого контекста' do
      subject { ability_for(manager_of(root)) }

      context 'управление контекстами' do
        it { should     be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should     be_able_to(:manage, child_2) }
      end

      context 'управление должностями' do
        it { should     be_able_to(:manage, child_1.items.new) }
        it { should     be_able_to(:manage, child_1_1.items.new) }
        it { should     be_able_to(:manage, child_2.items.new) }
      end

      context 'управление правами доступа' do
        it { should     be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end

    context 'вложенного контекста' do
      subject { ability_for(manager_of(child_1)) }

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

      context 'управление должностями' do
        it { should     be_able_to(:manage, child_1.items.new) }
        it { should     be_able_to(:manage, child_1_1.items.new) }
        it { should_not be_able_to(:manage, child_2.items.new) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end
  end

  context 'редактор' do
    context 'корневого контекста' do
      subject { ability_for(editor_of(root)) }

      context 'управление контекстами' do
        it { should     be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should     be_able_to(:manage, child_2) }
      end

      context 'управление должностями' do
        it { should     be_able_to(:manage, child_1.items.new) }
        it { should     be_able_to(:manage, child_1_1.items.new) }
        it { should     be_able_to(:manage, child_2.items.new) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end

    context 'вложенного контекста' do
      subject { ability_for(editor_of(child_1)) }

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

      context 'управление должностями' do
        it { should     be_able_to(:manage, child_1.items.new) }
        it { should     be_able_to(:manage, child_1_1.items.new) }
        it { should_not be_able_to(:manage, child_2.items.new) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end
  end

  context 'опреатор' do
    context 'корневого контекста' do
      subject { ability_for(operator_of(root)) }

      context 'изменение контекстов' do
        it { should     be_able_to(:modify, root) }
        it { should     be_able_to(:modify, child_1) }
        it { should     be_able_to(:modify, child_1_1) }
        it { should     be_able_to(:modify, child_2) }
      end

      context 'изменение html контекстов' do
        it { should_not be_able_to(:modify_dossier, root) }
        it { should_not be_able_to(:modify_dossier, child_1) }
        it { should_not be_able_to(:modify_dossier, child_1_1) }
        it { should_not be_able_to(:modify_dossier, child_2) }
      end

      context 'изменение должностей' do
        it { should     be_able_to(:modify, child_1.items.new) }
        it { should     be_able_to(:modify, child_1_1.items.new) }
        it { should     be_able_to(:modify, child_2.items.new) }
      end

      context 'изменение html должностей' do
        it { should_not be_able_to(:modify_dossier, child_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_1_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_2.items.new) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end

    context 'вложенного контекста' do
      subject { ability_for(operator_of(child_1)) }

      context 'изменение контекстов' do
        it { should_not be_able_to(:modify, root) }
        it { should     be_able_to(:modify, child_1) }
        it { should     be_able_to(:modify, child_1_1) }
        it { should_not be_able_to(:modify, child_2) }
      end

      context 'изменение html контекстов' do
        it { should_not be_able_to(:modify_dossier, root) }
        it { should_not be_able_to(:modify_dossier, child_1) }
        it { should_not be_able_to(:modify_dossier, child_1_1) }
        it { should_not be_able_to(:modify_dossier, child_2) }
      end

      context 'изменение должностей' do
        it { should     be_able_to(:modify, child_1.items.new) }
        it { should     be_able_to(:modify, child_1_1.items.new) }
        it { should_not be_able_to(:modify, child_2.items.new) }
      end

      context 'изменение html должностей' do
        it { should_not be_able_to(:modify_dossier, child_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_1_1.items.new) }
        it { should_not be_able_to(:modify_dossier, child_2.items.new) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end
  end
end
