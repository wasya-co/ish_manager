
class IshManager::Ability
  include ::CanCan::Ability

  def initialize user

    #
    # signed in user
    #
    if !user.blank?

      #
      # only sudoer... total power
      #
      if user.profile && user.profile.sudoer?
        can :manage, :all
      end

      can [ :home ], ::IshManager::Ability

      #
      # role admin
      #
      if user.profile && [ :admin ].include?( user.profile.role_name )

        can [ :friends_index, :friends_new ], ::Ish::UserProfile

        can [ :index, :new, :create, :create_photo ], ::Gallery
        can [ :edit, :update ], ::Gallery do |g|
          !g.is_trash && ( g.is_public || g.user_profile == user.profile )
        end
        can [ :edit, :index, :show, :update,
          :new_marker, :edit_marker, :create_marker, :update_marker,
        ], Gameui::Map

        can [ :home, :sites_index ], ::Manager

        can [ :new ], Newsitem

        can [ :index, :new, :create ], Report
        can [ :edit, :update, :destroy ], Report do |g|
          !g.is_trash && ( g.is_public || g.user_profile == user.profile )
        end

        # can [ :manage ], ::Warbler::StockWatch

        can [ :index, :new, :create ], ::Tag

        can [ :index, :new, :create ], ::Video
        can [ :edit, :update, :destroy ], ::Video do |v|
          !v.is_trash && ( v.is_public || v.user_profile == user.profile )
        end

      end

      #
      # role manager
      #
      if user.profile && :manager == user.profile.role_name

         can [ :edit, :index, :show, :update,
               :new_marker, :edit_marker, :create_marker, :update_marker,
         ], Gameui::Map

      end


      #
      # role guy (and manager)
      #
      if user.profile && [ :manager, :guy ].include?( user.profile.role_name )

        can [ :index, :new, :create ], ::Gallery
        can [ :show, :edit, :update, :create_photo ], ::Gallery do |gallery|
          gallery.user_profile == user.profile
        end
        can [ :show ], ::Gallery do |gallery|
          gallery.shared_profiles.include? user.profile
        end

        # can [ :index ], ::Report

        # can [ :index ], ::Video

      end

    end

    #
    # anonymous user
    #
    user ||= ::User.new

    can [ :open_permission ], IshManager::Ability

    can [ :show ], ::Gallery do |gallery|
      gallery.is_public
    end

    can [ :show ], ::Report do |report|
      report.is_public
    end

    can [ :new, :create ], Ish::EmailUnsubscribe

  end
end
