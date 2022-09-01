
class IshManager::UsersController < IshManager::ApplicationController

  def index
    @users = User.all
    authorize! :index, User
  end

  def show
    @user = User.find params[:id]
    authorize! :show, @user
  end

end

