module IshManager
  class ApplicationController < ActionController::Base
    # protect_from_forgery :with => :exception, :prepend => true
    before_action :set_current_ability
    check_authorization

    def home
      authorize! :home, IshManager::Ability
      render 'home'
    end

    private

    def set_current_ability
      @current_ability ||= ::IshManager::Ability.new( current_user )
    end

    def set_lists
      @sites_list = Site.all.list
      @cities_list = City.all.list
      @venues_list = Venue.all.list
      @reports_list = Report.all.list
      @galleries_list = Gallery.all.list
      @videos_list = Video.all.list
      @user_profiles_list = IshModels::UserProfile.all.list
      @tags_list = Tag.list
    end

    private

    def pp_errors err
      err
    end

    def puts! a, b=''
      puts "+++ +++ #{b}"
      puts a.inspect
    end

  end
end
