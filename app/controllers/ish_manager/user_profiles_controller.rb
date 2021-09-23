
class IshManager::UserProfilesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    @user_profiles = IshModels::UserProfile.all.includes( :user )
    authorize! :index, IshModels::UserProfile
  end

  def show
    @user_profile = IshModels::UserProfile.find params[:id]
    authorize! :show, @user_profile
  end

  def edit
    @profile = IshModels::UserProfile.find params[:id]
    authorize! :edit, @profile
  end

  def update
    @profile = IshModels::UserProfile.find params[:id]
    authorize! :update, @profile

    flag = @profile.update_attributes params[:profile].permit!
    if flag
      flash[:notice] = "Updated profile #{@profile.email}"
    else
      flash[:alert] = "Cannot update profile: #{pp_errors @profile.errors.messages}"
    end
    if params[:redirect_to]
      redirect_to params[:redirect_to]
    else
      redirect_to :action => :index
    end
  end

  def new
    @profile = IshModels::UserProfile.new
    authorize! :new, @profile
  end

  def create
    @user = User.find_or_create_by( :email => params[:profile][:email] )
    @user.password ||= (0...12).map { rand(100) }.join
    @user.profile = IshModels::UserProfile.new params[:profile].permit!
    authorize! :create, @user.profile
    if !@user.save
      raise "cannot save profile.user: #{@profile.user.errors.full_messages} profile errors: #{@profile.errors.full_messages}"
    end
    if @user.profile.save
      flash[:notice] = "Created profile"
    else
      flash[:alert] = "Cannot create profile: #{@profile.errors.messages}"
    end
    redirect_to :action => :index
  end

end

