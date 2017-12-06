class IshManager::FriendsController < IshManager::ApplicationController

  def index
    authorize! :friends_index, IshModels::UserProfile
    @new_friend = IshModels::UserProfile.new

    @friends = current_user.profile.friends
    friend_ids = @friends.map &:id
=begin
    @raw_shared_galleries = @friend.shared_galleries
    @shared_galleries = {}
    @friends.each do |f|
      @shared_galleries[f.email] = 
      f.shared_galleries
=end
  end

  def create
    @friend = ::IshModels::UserProfile.find_by( :email => params[:friend][:email] ) # .includes( :shared_galleries )

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


