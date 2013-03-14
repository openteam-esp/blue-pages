# encoding: utf-8

class Ability
  include CanCan::Ability

  def blue_pages
    @blue_pages ||= Category.find_by_title('Телефонный справочник')
  end

  def manager_of?(user, category)
    category.path.each { |category| return true if user.manager_of?(category) }

    false
  end

  def operator_of?(user, category)
    category.path.each { |category| return true if user.operator_of?(category) }

    false
  end

  def editor_of?(user, category)
    category.path.each { |category| return true if user.editor_of?(category) }

    false
  end

  def initialize(user)
    return unless user

    can :manage, :all if user.manager_of?(blue_pages)

    can :manage, :application if user.permissions.any?

    can :read, User if user.manager?

    can :manage, Category do |category|
      manager_of?(user, category)
    end

    can :manage, Permission do |permission|
      manager_of?(user, permission.context)
    end

    can :create, Permission if user.manager?

    alias_action :create, :read, :update, :destroy, :treeview, :sort, :to => :modify

    can :manage, Category do |category|
      editor_of?(user, category)
    end

    can :modify, Category do |category|
      operator_of?(user, category)
    end

    can :manage, Item do |item|
      manager_of?(user, item.itemable)
    end

    can :manage, Item do |item|
      editor_of?(user, item.itemable)
    end

    can :modify, Item do |item|
      operator_of?(user, item.itemable)
    end
  end
end
