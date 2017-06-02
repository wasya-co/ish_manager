
class IshManager::Ability
  include ::CanCan::Ability

  def initialize user 

    #
    # signed in user
    #
    unless user.blank?

      if user.profile && user.profile.manager?
        can :manage, :all
        can [ :home ], ::Manager
        can :destroy, ::Photo
      end

      can [ :show ], ::Gallery do |gallery|
        gallery.user == user
      end
      
    end
    #
    # anonymous user
    #
    user ||= ::User.new
    
    can [ :show ], ::Gallery do |gallery|
      gallery.is_public
    end

    can [ :show ], ::Report do |report|
      report.is_public
    end
    
  end
end
