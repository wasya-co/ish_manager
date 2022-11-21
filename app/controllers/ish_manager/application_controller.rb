
module IshManager
  class ApplicationController < ActionController::Base
    protect_from_forgery :with => :exception, :prepend => true
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
      @current_profile ||= ::Ish::UserProfile.find_by({ email: current_user.email })
      @current_ability ||= ::IshManager::Ability.new( @current_profile )
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

    # @TODO: obsolete, remove _vp_ 2022-10-15
    def update_profile_pic
      return unless params[:photo]
      @photo = Photo.new :photo => params[:photo]
      @photo.user_profile = @current_profile
      flag = @photo.save
      @resource.profile_photo = @photo
      flagg = @resource.save
      if flag && flagg
        flash[:notice] = 'Success'
      else
        flash[:alert] = "No Luck. #{@photo.errors.messages} #{@resource.errors.messages}"
      end
    end

  end
end
