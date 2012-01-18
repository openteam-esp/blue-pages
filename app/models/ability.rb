class Ability
  include CanCan::Ability


  def initialize(user)
    return unless user

    alias_action :create, :read, :update, :destroy, :treeview, :to => :modify

    can :modify, Category do |category|
      (user.category_ids & category.ancestor_ids + [category.id]).any?
    end

    can :modify, Item do |item|
      can? :modify, item.subdivision
    end

    can :modify_dossier, Category do | category |
      (user.categories.where(:permissions => {:role => [:editor, :manager]}) & category.ancestors + [category]).any?
    end

    can :modify_dossier, Item do | item |
      can? :modify_dossier, item.subdivision
    end

    can :modify, User do
      user.permissions.where(:role => :manager).exists?
    end

    can :modify, Permission do | permission |
      permission.new_record? && permission.context.nil? && can?(:modify, permission.user)
    end

    can :modify, Permission do | permission |
      can?(:modify, permission.context) && can?(:modify, permission.user)
    end
  end
end
