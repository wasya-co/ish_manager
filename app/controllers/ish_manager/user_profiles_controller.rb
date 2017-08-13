
class IshManager::UserProfilesController < IshManager::ApplicationController

  def index
    @user_profiles = IshModels::UserProfile.all
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
    flag = @profile.update_attributes params[:ish_models_user_profile].permit!
    if flag
      flash[:notice] = "Updated profile #{@profile.email}"
    else
      flash[:alert] = "Cannot update profile: #{pp_errors @profile.errors.messages}"
    end
    redirect_to :action => :index
  end

end

