module IshManager
  class ApplicationController < ActionController::Base
    # protect_from_forgery :with => :exception, :prepend => true
    before_action :set_current_ability
    before_action :set_changelog
    check_authorization
    rescue_from ::CanCan::AccessDenied, :with => :access_denied

    def home
      authorize! :home, IshManager::Ability
      render 'home'
    end

    #
    # private
    #
    private

    def set_changelog
      @version = Gem.loaded_specs['ish_manager'].version.to_s
    end

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

    def access_denied exception
      store_location_for :user, request.path
      redirect_to user_signed_in? ? root_path : Rails.application.routes.url_helpers.new_user_session_path, :alert => exception.message
    end

    def pp_errors err
      err
    end

    def puts! a, b=''
      puts "+++ +++ #{b}"
      puts a.inspect
    end

  end
end
