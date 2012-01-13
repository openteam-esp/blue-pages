class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Category do |category|
      (user.category_ids & category.ancestor_ids + [category.id]).any?
    end

    can :manage, Item do |item|
      can? :manage, item.subdivision
    end

    can :manage, User do
      user.permissions.where(:role => :manager).exists?
    end

    can :manage, Permission do | permission |
      permission.new_record? && permission.context.nil? && can?(:manage, permission.user)
    end

    can :manage, Permission do | permission |
      can?(:manage, permission.context) && can?(:manage, permission.user)
    end
  end
end
