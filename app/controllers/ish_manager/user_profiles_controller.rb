
class IshManager::UserProfilesController < IshManager::ApplicationController

  def index
    @user_profiles = IshModels::UserProfile.all
    authorize! :index, IshModels::UserProfile
  end

  def show
    @user_profile = IshModels::UserProfile.find params[:id]
    authorize! :show, @user_profile
  end

end

