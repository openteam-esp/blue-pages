class AdminAbility
  include CanCan::Ability

  def initialize(user)
    can :read, [Item, Subdivision]

    can :manage, Subdivision do |subdivision|
      subdivision.admin_users.include?(user) || subdivision.ancestors.map(&:admin_users).flatten.include?(user)
    end

    can :manage, Item do |item|
      can? :manage, item.subdivision
    end
  end
end
