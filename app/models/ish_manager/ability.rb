
class IshManager::Ability
  include ::CanCan::Ability

  def initialize user 

    #
    # signed in user
    #
    unless user.blank?

      # role manager
      if user.profile && user.profile.role_name == :manager

        can [ :create_newsitem, :show ], ::City

        can [ :cities_index, :home, :sites_index, :venues_index ], ::Manager

        can [ :new ], Newsitem

        can [ :new, :create ], Report

        can [ :show, :edit, :update, :create_newsitem ], ::Site do |site|
          !site.is_private && !site.is_trash
        end

      end

      if user.profile && user.profile.sudoer?
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
