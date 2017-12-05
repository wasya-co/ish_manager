class IshManager::FriendsController < IshManager::ApplicationController

  def index
    authorize! :friends_index, IshModels::UserProfile
    @new_friend = IshModels::UserProfile.new
  end

  def create
    @friend = ::IshModels::UserProfile.find_by :email => params[:friend][:email]
    puts! @friend, 'friend!'

    authorize! :friends_new, @friend

    me = current_user.profile
    me.friends << @friend
    if me.save
      flash[:notice] = 'Added Friend'
    else
      flash[:alert] = "Cannot add friend: #{me.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end


