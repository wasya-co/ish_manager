
class IshManager::Ability
  include ::CanCan::Ability

  def initialize user_profile

    #
    # signed in user
    #
    if !user_profile.blank?

      #
      # only sudoer... total power
      #
      if user_profile.sudoer?
        can :manage, :all
      end

      can [ :home ], ::IshManager::Ability

      #
      # role admin
      #
      if user_profile && [ :admin ].include?( user_profile.role_name )

        can [ :friends_index, :friends_new ], ::Ish::UserProfile

        can [ :index, :new, :create, :create_photo ], ::Gallery
        can [ :edit, :update ], ::Gallery do |g|
          !g.is_trash && ( g.is_public || g.user_profile == user_profile )
        end
        can [ :edit, :index, :show, :update,
          :new_marker, :edit_marker, :create_marker, :update_marker,
        ], Gameui::Map

        can [ :home, :sites_index ], ::Manager

        can [ :new ], Newsitem

        can [ :index, :new, :create ], Report
        can [ :edit, :update, :destroy ], Report do |g|
          !g.is_trash && ( g.is_public || g.user_profile == user_profile )
        end

        # can [ :manage ], ::Warbler::StockWatch

        # can [ :index, :new, :create ], ::Tag

        can [ :index, :new, :create ], ::Video
        can [ :edit, :update, :destroy ], ::Video do |v|
          !v.is_trash && ( v.is_public || v.user_profile == user_profile )
        end

      end

      #
      # role manager
      #
      if user_profile && :manager == user_profile.role_name

         can [ :edit, :index, :show, :update,
               :new_marker, :edit_marker, :create_marker, :update_marker,
         ], Gameui::Map

      end


      #
      # role guy
      #
      if user_profile && :guy == user_profile.role_name

        can [ :index, :new, :create ], ::Gallery
        can [ :show, :edit, :update, :create_photo ], ::Gallery do |gallery|
          gallery.user_profile == user_profile
        end
        can [ :show ], ::Gallery do |gallery|
          gallery.shared_profiles.include? user_profile
        end

        # can [ :create, :index, :new ], Photo

        # can [ :index ], ::Report

        # can [ :index ], ::Video

      end

    end

    #
    # anonymous user
    #
    user_profile ||= ::Ish::UserProfile.new

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
