class Ability
  include CanCan::Ability


  def initialize(user)

    return unless user

    alias_action :create, :read, :update, :destroy, :treeview, :sort, :to => :modify

    can :modify, Category do | category |
      user.permissions.for_context(category).exists?
    end

    can :modify, Item do |item|
      can? :modify, item.subdivision
    end

    can :modify_dossier, Category do | category |
      user.permissions.for_roles(:manager, :editor).for_context(category).exists?
    end

    can :modify_dossier, Item do | item|
      can? :modify_dossier, item.subdivision
    end

    can :manage, Permission do | permission |
      permission.context && user.permissions.for_roles(:manager).for_context(permission.context).exists?
    end

    can :create, Permission do | permission |
      user.manager?
    end

    can :manage, User do
      user.manager?
    end
  end
end
