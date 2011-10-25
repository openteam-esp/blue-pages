class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Subdivision

    can :manage, Subdivision do |subdivision|
      subdivision.admin_users.include?(user) || subdivision.ancestors.map(&:admin_users).flatten.include?(user)
    end
  end
end
