
class IshManager::TagsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def create
    @tag = Tag.create params[:tag].permit!
    authorize! :create, @tag
    if @tag.save
      do_touch
      flash[:notice] = 'Success.'
      redirect_to tags_path
    else
      puts! @tag.errors, "error creating tag."
      flash[:alert] = "No luck. #{@tag.errors.full_messages}"
      render action: 'new'
    end
  end

  def destroy
    @tag = Tag.unscoped.find params[:id]
    authorize! :destroy, @tag
    if @tag.destroy
      do_touch
      flash[:notice] = 'Success'
    else
      flash[:alert] = "Cannot destroy tag: #{@tag.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def edit
    @tag = Tag.unscoped.find params[:id]
    authorize! :edit, @tag
  end

  def index
    @resource = City.find( params[:city_id] ) if params[:city_id]

    if @resource
      @tags = @resource.tags
    else
      @tags = Tag.unscoped.where( :parent_tag_id => nil ).order_by( :name => :asc )
    end

    authorize! :index, Tag.new

    @site = Site.find( params[:site_id] ) if params[:site_id]
    @city = City.find( params[:city_id] ) if params[:city_id]
  end

  def new
    @tag = Tag.new
    authorize! :new, @tag
  end

  def show
    @tag = Tag.unscoped.find params[:id]
    authorize! :show, @tag

    @galleries = @tag.galleries.unscoped.where( :is_trash => false ).page( params[:galleries_page] ).per( 10 )
    @videos = @tag.videos.unscoped.where( :is_trash => false ).page( params[:videos_page ]).per( 10 )
  end

  def update
    @tag = Tag.unscoped.find params[:id]
    authorize! :update, @tag

    if @tag.update_attributes params[:tag].permit!
      do_touch
      flash[:notice] = 'Success.'
      redirect_to tags_path
    else
      flash[:alert] = 'No luck.'
      render :action => :new
    end
  end


  private

  def do_touch
    @tag.city.touch if @tag.city
    @tag.site.touch if @tag.site
  end

end


