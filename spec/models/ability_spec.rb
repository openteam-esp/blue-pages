# encoding: utf-8

require 'spec_helper'

describe Ability do
  let(:child_1) { Fabricate :subdivision, :parent => root }
  let(:child_1_1) { Fabricate :subdivision, :parent => child_1 }
  let(:child_2) { Fabricate :subdivision, :parent => root }

  shared_examples_for 'может управлять подразделениями' do
    it { should     be_able_to(:manage, root) }
    it { should     be_able_to(:manage, child_1) }
    it { should     be_able_to(:manage, child_1_1) }
    it { should     be_able_to(:manage, child_2) }
  end

  shared_examples_for 'может управлять подразделами' do
    it { should     be_able_to(:manage, child_1.categories.new) }
    it { should     be_able_to(:manage, child_1_1.categories.new) }
    it { should     be_able_to(:manage, child_2.categories.new) }
  end

  shared_examples_for 'может управлять должностями' do
    it { should     be_able_to(:manage, child_1.items.new) }
    it { should     be_able_to(:manage, child_1_1.items.new) }
    it { should     be_able_to(:manage, child_2.items.new) }
  end

  shared_examples_for 'может управлять правами доступа' do
    it { should     be_able_to(:manage, another_manager_of(root).permissions.first) }
    it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
    it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
    it { should     be_able_to(:manage, another_manager_of(child_2).permissions.first) }
  end

  shared_examples_for 'может управлять своими подразделениями' do
    it { should_not be_able_to(:manage, root) }
    it { should     be_able_to(:manage, child_1) }
    it { should     be_able_to(:manage, child_1_1) }
    it { should_not be_able_to(:manage, child_2) }
  end

  shared_examples_for 'может управлять своими подразделами' do
    it { should_not be_able_to(:manage, root.categories.new) }
    it { should     be_able_to(:manage, child_1.categories.new) }
    it { should     be_able_to(:manage, child_1_1.categories.new) }
    it { should_not be_able_to(:manage, child_2.categories.new) }
  end

  shared_examples_for 'может управлять своими должностями' do
    it { should     be_able_to(:manage, child_1.items.new) }
    it { should     be_able_to(:manage, child_1_1.items.new) }
    it { should_not be_able_to(:manage, child_2.items.new) }
  end

  shared_examples_for 'может управлять своими правами доступа' do
    it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
    it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
    it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
    it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
  end

  shared_examples_for 'не может управлять правами доступа' do
    it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
    it { should_not be_able_to(:manage, another_manager_of(child_1).permissions.first) }
    it { should_not be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
    it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
  end

  context 'менеджер' do
    context 'корневого контекста' do
      subject { ability_for(manager_of(root)) }

      it_should_behave_like 'может управлять подразделениями'
      it_should_behave_like 'может управлять подразделами'
      it_should_behave_like 'может управлять должностями'
      it_should_behave_like 'может управлять правами доступа'
    end

    context 'вложенного контекста' do
      subject { ability_for(manager_of(child_1)) }

      it_should_behave_like 'может управлять своими подразделениями'
      it_should_behave_like 'может управлять своими подразделами'
      it_should_behave_like 'может управлять своими должностями'
      it_should_behave_like 'может управлять своими правами доступа'
    end
  end

  context 'редактор' do
    context 'корневого контекста' do
      subject { ability_for(editor_of(root)) }

      it_should_behave_like 'может управлять подразделениями'
      it_should_behave_like 'может управлять подразделами'
      it_should_behave_like 'может управлять должностями'
      it_should_behave_like 'не может управлять правами доступа'
    end

    context 'вложенного контекста' do
      subject { ability_for(editor_of(child_1)) }

      it_should_behave_like 'может управлять своими подразделениями'
      it_should_behave_like 'может управлять своими подразделами'
      it_should_behave_like 'может управлять своими должностями'
      it_should_behave_like 'не может управлять правами доступа'
    end
  end

  context 'опреатор' do
    shared_examples_for 'не может изменять html подразделения' do
      it { should_not be_able_to(:modify_dossier, root) }
      it { should_not be_able_to(:modify_dossier, child_1) }
      it { should_not be_able_to(:modify_dossier, child_1_1) }
      it { should_not be_able_to(:modify_dossier, child_2) }
    end

    shared_examples_for 'не может изменять html должности' do
      it { should_not be_able_to(:modify_dossier, root) }
      it { should_not be_able_to(:modify_dossier, child_1) }
      it { should_not be_able_to(:modify_dossier, child_1_1) }
      it { should_not be_able_to(:modify_dossier, child_2) }
    end

    context 'корневого контекста' do
      subject { ability_for(operator_of(root)) }

      context 'изменение подразделений' do
        it { should     be_able_to(:modify, root) }
        it { should     be_able_to(:modify, child_1) }
        it { should     be_able_to(:modify, child_1_1) }
        it { should     be_able_to(:modify, child_2) }
      end

      context 'изменение подразделов' do
        it { should     be_able_to(:modify, root.categories.new) }
        it { should     be_able_to(:modify, child_1.categories.new) }
        it { should     be_able_to(:modify, child_1_1.categories.new) }
        it { should     be_able_to(:modify, child_2.categories.new) }
      end

      context 'изменение должностей' do
        it { should     be_able_to(:modify, child_1.items.new) }
        it { should     be_able_to(:modify, child_1_1.items.new) }
        it { should     be_able_to(:modify, child_2.items.new) }
      end

      it_should_behave_like 'не может изменять html подразделения'
      it_should_behave_like 'не может изменять html должности'
      it_should_behave_like 'не может управлять правами доступа'
    end

    context 'вложенного контекста' do
      subject { ability_for(operator_of(child_1)) }

      context 'изменение подразделений' do
        it { should_not be_able_to(:modify, root) }
        it { should     be_able_to(:modify, child_1) }
        it { should     be_able_to(:modify, child_1_1) }
        it { should_not be_able_to(:modify, child_2) }
      end

      context 'изменение подразделов' do
        it { should_not be_able_to(:modify, root.categories.new) }
        it { should     be_able_to(:modify, child_1.categories.new) }
        it { should     be_able_to(:modify, child_1_1.categories.new) }
        it { should_not be_able_to(:modify, child_2.categories.new) }
      end

      context 'изменение должностей' do
        it { should     be_able_to(:modify, child_1.items.new) }
        it { should     be_able_to(:modify, child_1_1.items.new) }
        it { should_not be_able_to(:modify, child_2.items.new) }
      end

      it_should_behave_like 'не может изменять html подразделения'
      it_should_behave_like 'не может изменять html должности'
      it_should_behave_like 'не может управлять правами доступа'
    end
  end
end
