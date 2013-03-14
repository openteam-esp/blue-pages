class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all

    ## common
    #can :manage, Category do | context |
      #user.manager_of? context
    #end

    #can :manage, Permission do | permission |
      #permission.context && user.manager_of?(permission.context)
    #end

    #can [:new, :create], Permission do | permission |
      #!permission.context && user.manager?
    #end

    #can [:search, :index], User do
      #user.manager?
    #end

    #can :manage, :application do
      #user.have_permissions?
    #end

    #can :manage, :permissions do
      #user.manager?
    #end

    #can :manage, :audits do
      #user.manager_of? Category.first
    #end

    ## app specific

    #alias_action :create, :read, :update, :destroy, :treeview, :sort, :to => :modify

    #can :manage, Category do | category |
      #user.editor_of? category
    #end

    #can :modify, Category do | category |
      #user.operator_of? category
    #end

    #can :manage, Item do | item |
      #user.manager_of? item.itemable
    #end

    #can :manage, Item do | item |
      #user.editor_of? item.itemable
    #end

    #can :modify, Item do | item |
      #user.operator_of? item.itemable
    #end
  end
end
