
class IshManager::VideosController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def create
    @video = Video.new params[:video].permit(%i| name descr is_public is_trash is_feature x y lang youtube_id
      site user_profile premium_tier premium_purchases thumb video |)
    @video.user_profile = current_user.profile
    if !params[:video][:site_id].blank?
      @video.site = Site.find params[:video][:site_id]
      @video.site.touch
    else
      if @site
        @video.site = @site
        @site.touch
      end
    end
    authorize! :create, @video

    if @video.save
      flash[:notice] = 'Success'
      redirect_to videos_path
    else
      flash[:alert] = 'No luck'
      @tags_list = Tag.list
      render :action => 'new'
    end
  end

  def destroy
    @video = Video.unscoped.find params[:id]
    authorize! :destroy, @video
    flag = @video.delete
    @video.site.touch if @video.site
    @video.tags.map &:touch
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

    @tags_list = Tag.unscoped.or( { :is_public => true }, { :user_id => current_user.id } ).list
  end

  def index
    authorize! :index, Video.new
    @videos = Video.unscoped.where( is_trash: false, :user_profile => current_user.profile ).order_by( :created_at => :desc )

    if params[:tag_id]
      tag = Tag.find params[:tag_id]
      @videos = @videos.where( :tag => tag )
    end

    if params[:site_id]
      @site = Site.find params[:site_id]
      @videos = @site.videos
    end

    if params[:q]
      @videos = @videos.where({ :name => /#{params[:q]}/i })
    end

    @videos = @videos.page( params[:videos_page] ).per( 10 )

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

    @tags_list = Tag.unscoped.or( { :is_public => true }, { :user_id => current_user.id } ).list
  end

  def update
    @video = Video.unscoped.find params[:id]
    authorize! :update, @video

    @video.update params[:video].permit!
    if @video.save
      @video.site.touch if @video.site
      flash[:notice] = 'Success.'
      redirect_to videos_path
    else
      flash[:alert] = "No luck: #{@video.errors.messages}"
      render :edit
    end
  end

end
