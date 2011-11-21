class AdminAbility
  include CanCan::Ability

  def initialize(user)
    can :read, [Item, Category]

    # TODO: написать как надо
    can :manage, Category

    can :manage, Category do |category|
      user && user.manageable_categories.include?(category)
    end

    can :manage, Item do |item|
      can? :manage, item.subdivision
    end

    can [:destroy, :update], AdminUser do | admin_user |
      (user.categories & (admin_user.categories.map(&:ancestors).flatten + admin_user.categories)).any?
    end

    can :manage, AdminUser do | admin_user |
      user.categories.include? Category.root
    end

    can [:create, :read], AdminUser
  end
end
