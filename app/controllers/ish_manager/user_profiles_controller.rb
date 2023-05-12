
class IshManager::UserProfilesController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @user = User.find_or_create_by( :email => params[:profile][:email] )
    @user.password ||= (0...12).map { rand(100) }.join
    @user_profile = Ish::UserProfile.new params[:profile].permit!
    authorize! :create, @user_profile

    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      @user_profile.profile_photo = photo
    end

    if !@user.save
      raise "cannot save profile.user: #{@user.errors.full_messages} profile errors: #{@user_profile.errors.full_messages}"
    end
    if @user_profile.save
      flash[:notice] = "Created profile"
    else
      flash[:alert] = "Cannot create profile: #{@user_profile.errors.messages}"
    end
    redirect_to :action => :index
  end

  def edit
    @profile = Ish::UserProfile.find params[:id]
    authorize! :edit, @profile
  end

  def index
    @user_profiles = Ish::UserProfile.all
    authorize! :index, Ish::UserProfile
    if params[:q]
      @user_profiles = @user_profiles.where({ :email => /#{params[:q]}/i })
    end
  end

  def new
    @profile = Ish::UserProfile.new
    authorize! :new, @profile
  end

  def show
    @profile = Ish::UserProfile.find params[:id]
    authorize! :show, @profile
  end

  def update
    @profile = Ish::UserProfile.find params[:id]
    authorize! :update, @profile

    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      @profile.profile_photo = photo
    end

    flag = @profile.update_attributes params[:profile].permit!

    if flag
      flash[:notice] = "Updated profile #{@profile.email}"
    else
      flash[:alert] = "Cannot update profile: #{@profile.errors.full_messages}"
    end
    if params[:redirect_to]
      redirect_to params[:redirect_to]
    else
      redirect_to request.referrer
    end
  end

end

