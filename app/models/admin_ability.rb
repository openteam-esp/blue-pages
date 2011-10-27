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

    # TODO: переписать с учетом категорий
    can [:create, :read], AdminUser

    can [:destroy, :update], AdminUser do |admin_user|
      (user.manageable_subdivisions & admin_user.subdivisions).any?
    end
  end
end
