class IshManager::FriendsController < IshManager::ApplicationController

  def index
    authorize! :friends_index, Ish::UserProfile
    @new_friend = Ish::UserProfile.new

    @friends = current_user.profile.friends
    friend_ids = @friends.map &:id
  end

  def create
    @friend = ::Ish::UserProfile.find_by( :email => params[:friend][:email] ) # .includes( :shared_galleries )

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


