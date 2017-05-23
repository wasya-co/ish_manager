
class IshManager::Ability
  include ::CanCan::Ability

  def initialize user
    user ||= User.new

    if user.profile && user.profile.manager?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
