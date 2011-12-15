class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Item, Category]

    can :manage, Category do |category|
      user && (user.manageable_categories.include?(category) || user.manageable_categories.include?(category.parent))
    end

    can :manage, Item do |item|
      can? :manage, item.subdivision
    end

    can [:destroy, :update], User do | another_user |
      (user.categories & (another_user.categories.map(&:ancestors).flatten + another_user.categories)).any?
    end

    can :manage, User do
      user.categories.include? Category.root
    end

    can [:create, :read], User do
      user.categories.any?
    end
  end
end
