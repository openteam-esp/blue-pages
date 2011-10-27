class AdminAbility
  include CanCan::Ability

  def initialize(user)
    can :read, [Item, Category]

    can :manage, Category do |category|
      user.manageable_categories.include?(category)
    end

    can :manage, Item do |item|
      can? :manage, item.subdivision
    end

    # TODO: переписать с учетом категорий
    can [:create, :read], AdminUser

    can [:destroy, :update], AdminUser do |admin_user|
      (user.manageable_categories & admin_user.categories).any?
    end
  end
end
