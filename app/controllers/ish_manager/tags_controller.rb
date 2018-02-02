
class IshManager::TagsController < IshManager::ApplicationController

  before_action :set_lists

  def index
    @tags = Tag.unscoped.where( :parent_tag_id => nil ).order_by( :name => :asc )
    authorize! :index, Tag.new

    @site = Site.find( params[:site_id] ) if params[:site_id] 
    @city = City.find( params[:city_id] ) if params[:city_id] 
  end
  
  def show
    @tag = Tag.unscoped.find params[:id]
    authorize! :show, @tag

    @galleries = @tag.galleries.unscoped.where( :is_trash => false ).page( params[:galleries_page] ).per( 10 )
    @videos = @tag.videos.unscoped.where( :is_trash => false ).page( params[:videos_page ]).per( 10 )
  end

  def new
    @tag = Tag.new
    authorize! :new, @tag
  end

  def create
    @tag = Tag.create params[:tag].permit!
    authorize! :create, @tag
    if @tag.save
      flash[:notice] = 'Success.'
      redirect_to tags_path
    else
      puts! @tag.errors, "error creating tag."
      flash[:error] = "No luck. #{@tag.errors.messages}" 
      render :action => :new
    end
  end

  def edit
    @tag = Tag.unscoped.find params[:id]
    authorize! :edit, @tag
  end

  def update
    @tag = Tag.unscoped.find params[:id]
    authorize! :update, @tag

    if @tag.update_attributes params[:tag].permit!
      @tag.site.touch if @tag.site

      flash[:notice] = 'Success.'
      redirect_to tags_path
    else
      flash[:error] = 'No luck.'
      render :action => :new
    end
  end

  def destroy
    @tag = Tag.unscoped.find params[:id]
    authorize! :destroy, @tag
    if @tag.destroy
      flash[:notice] = 'Success'
    else
      flash[:alert] = "Cannot destroy tag: #{@tag.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end


