# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.manager_of?(Category.root)

    can :manage, :application if user.permissions.any?

    can :read, User if user.manager?

    can :manage, Permission do |permission|
      permission.context && user.manager_of?(permission.context)
    end

    can :create, Permission do |permission|
      !permission.context && user.manager?
    end

    alias_action :create, :read, :update, :destroy, :treeview, :sort, :to => :modify

    can :manage, Category do |category|
      user.manager_of?(category)
    end

    can :manage, Category do |category|
      user.editor_of?(category)
    end

    can :modify, Category do |category|
      user.operator_of?(category)
    end

    can :manage, Item do |item|
      can? :manage, item.itemable
    end

    can :modify, Item do |item|
      can? :modify, item.itemable
    end
  end
end
