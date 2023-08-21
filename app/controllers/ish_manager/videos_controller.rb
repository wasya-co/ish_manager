
class IshManager::VideosController < IshManager::ApplicationController

  before_action :set_lists

  # Alphabetized : )

  def create
    @video = Video.new params[:video].permit(%i| name descr is_public is_trash is_feature x y lang youtube_id
      site user_profile premium_tier premium_purchases thumb video |)
    @video.user_profile = @current_profile
    authorize! :create, @video

    if @video.save
      flash[:notice] = 'Success'
      redirect_to videos_path
    else
      flash[:alert] = 'No luck'
      render :action => 'new'
    end
  end

  def destroy
    @video = Video.unscoped.find params[:id]
    authorize! :destroy, @video
    flag = @video.delete
    if flag
      flash[:notice] = "deleted video"
    else
      flash[:alert] = "Cannot delete video: #{@video.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def edit
    @video = Video.unscoped.find params[:id]
    @user_profiles_list = Ish::UserProfile.list
    authorize! :edit, @video
  end

  def index
    authorize! :index, Video.new
    @videos = Video.unscoped.where( is_trash: false,
      :user_profile => @current_profile
    ).order_by( :created_at => :desc )

    if params[:q]
      @videos = @videos.where({ :name => /#{params[:q]}/i })
    end

    @videos = @videos.page( params[:videos_page] ).per( 9 )

    respond_to do |format|
      format.html do
        render
      end
      format.json do
        render :json => @videos
      end
    end
  end

  def show
    @video = Video.unscoped.where( :youtube_id => params[:youtube_id] ).first if params[:youtube_id].present?
    @video ||= Video.unscoped.find params[:id]
    authorize! :show, @video

    respond_to do |format|
      format.html
      format.json do
        render :json => @video
      end
    end
  end

  def new
    @video = Video.new
    authorize! :new, @video
  end

  def update
    @video = Video.unscoped.find params[:id]
    authorize! :update, @video

    old_shared_profile_ids = @video.shared_profile_ids
    if params[:video][:shared_profiles].present?
      params[:video][:shared_profiles].delete('')
    end
    params[:video][:shared_profile_ids] = params[:video][:shared_profiles]
    params[:video].delete :shared_profiles

    @video.update params[:video].permit!
    if @video.save

      # if params[:video][:shared_profile_ids].present?
      #   new_shared_profiles = Ish::UserProfile.find( params[:video][:shared_profile_ids]
      #     ).select { |p| !old_shared_profile_ids.include?( p.id ) }
      #   ::IshManager::ApplicationMailer.shared_video( new_shared_profiles, @video ).deliver
      # end

      flash[:notice] = 'Success.'
      redirect_to video_path(@video)
    else
      flash[:alert] = "No luck: #{@video.errors.messages}"
      render :edit
    end
  end

end
