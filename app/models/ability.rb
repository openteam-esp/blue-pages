class Ability
  include CanCan::Ability


  def initialize(user)
    return unless user

    alias_action :create, :read, :update, :destroy, :treeview, :sort, :to => :modify

    can :modify, Category do |category|
      (user.context_ids & category.ancestor_ids + [category.id]).any?
    end

    can :modify, Item do |item|
      can? :modify, item.subdivision
    end

    can :modify_dossier, Category do | category |
      (user.contexts_for([:editor, :manager]) & category.ancestors + [category]).any?
    end

    can :modify_dossier, Item do | item |
      can? :modify_dossier, item.subdivision
    end

    can :modify, User do
      user.manager?
    end

    can :modify, Permission do | permission |
      permission.new_record? && permission.context.nil? && user.manager?
    end

    can :modify, Permission do | permission |
      can?(:modify, permission.context) && can?(:modify, permission.user)
    end
  end
end
