class AdminAbility
  include CanCan::Ability

  def initialize(user)
    can :read, [Item, Subdivision]

    can :manage, Subdivision do |subdivision|
      user.manageable_subdivisions.include?(subdivision)
    end

    can :manage, Item do |item|
      can? :manage, item.subdivision
    end
  end
end
