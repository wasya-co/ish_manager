
require 'business_time'


class IshManager::ApplicationController < ActionController::Base

  protect_from_forgery :with => :exception, :prepend => true
  before_action :set_current_ability
  before_action :set_changelog
  before_action :set_title
  before_action :set_jwt
  check_authorization
  rescue_from ::CanCan::AccessDenied, :with => :access_denied

  before_action :basic_auth
  def basic_auth
    return if Rails.env.test?
    http_basic_authenticate_or_request_with :name => BASIC_AUTH_NAME, :password => BASIC_AUTH_PASSWORD
  end

  def home
    authorize! :home, IshManager::Ability
    render 'home'
  end

  def tinymce
    authorize! :home, IshManager::Ability
    render layout: false
  end

  ##
  ## private
  ##
  private

  def access_denied exception
    store_location_for :user, request.path
    redirect_to user_signed_in? ? root_path : Rails.application.routes.url_helpers.new_user_session_path, :alert => exception.message
  end

  def current_profile
    return @current_profile if @current_profile
    if current_user&.email
      return @current_profile = Ish::UserProfile.find_by({ email: current_user.email })
    end
  end

  def encode(payload, exp = 48.hours.from_now) # @TODO: definitely change, right now I expire once in 2 days.
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base.to_s)
  end

  def my_truthy? which
    ["1", "t", "T", "true"].include?( which )
  end

  def pp_errors err
    err
  end

  def puts! a, b=''
    puts "+++ +++ #{b}"
    puts a.inspect
  end

  def set_changelog
    @version = Gem.loaded_specs['ish_manager'].version.to_s
  end

  def set_current_ability
    if !current_user
      raise ::CanCan::AccessDenied
    end
    @current_profile ||= ::Ish::UserProfile.find_by({ email: current_user.email })
    @current_ability ||= ::IshManager::Ability.new( @current_profile )
  end

  def set_jwt
    @jwt_token = encode(user_profile_id: @current_user.profile.id.to_s)
  end

  def set_lists
    @blank_template       = Tmpl.new

    @email_campaigns_list = [[nil,nil]] + Ish::EmailCampaign.all.map { |c| [ c.slug, c.id ] }
    @email_actions_list   = [[nil,nil]] + Office::EmailAction.all.map { |a| [ a.slug, a.id ] }
    @email_templates_list = [[nil,nil]] + Ish::EmailTemplate.all.map { |t| [ t.slug, t.id ] }
    @email_tags_list      = [[nil,nil]] + WpTag.email_tags.map { |t| [ t.name, t.id ] }
    @galleries_list       = Gallery.all.list
    @leads_list           = Lead.list
    @leadsets_list        = Leadset.list
    @locations_list       = ::Gameui::Map.list
    @maps_list            = ::Gameui::Map.list # @TODO: missing nonpublic!
    @office_actions_list  = [[nil,nil]] + Office::Action.all.map { |a| [ a.slug, a.id ] }
    @option_watches_list  = [nil] + Iro::OptionWatch.where({ kind: Iro::OptionWatch::KIND_GET_CHAINS }).order_by({ ticket: :desc }).map( &:ticker )
    @profiles_list        = Ish::UserProfile.list
    @reports_list         = Report.all.list
    @tags_list            = [[nil,nil]] + WpTag.all.map { |t| [ t.name, t.id ] }
    @user_profiles_list   = Ish::UserProfile.list
    @videos_list          = Video.all.list
  end

  def set_title
    @page_title = "#{ params[:controller].gsub('ish_manager/', '') } #{params[:action]} #{params[:slug]||params[:id]} ".gsub("  ", " ")
  end


end





