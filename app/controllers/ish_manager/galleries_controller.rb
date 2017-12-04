class IshManager::GalleriesController < IshManager::ApplicationController

  before_action :set_lists
  
  def index
    authorize! :index, Gallery
    @galleries = Gallery.unscoped.where( :is_trash => false, :user_profile => current_user.profile
                                       ).order_by( :created_at => :desc 
                                                 ).page( params[:galleries_page] ).per( 10 )
    @shared_galleries = current_user.profile.shared_galleries
  end

  def index_thumb
    @galleries = Gallery.unscoped.where( :is_trash => false 
                                       ).order_by( :created_at => :desc 
                                                 ).page( params[:galleries_page] ).per( 10 )
  end

  def index_mini
    @galleries = Gallery.unscoped.where( :is_trash => false 
                                       ).order_by( :created_at => :desc 
                                                 ).page( params[:galleries_page] ).per( 10 )
  end

  def new
    @gallery = Gallery.new
    authorize! :new, @gallery
    @cities_list = City.list
    @tags_list = Tag.list
  end

  def create
    @gallery = Gallery.new params[:gallery].permit!
    authorize! :create, @gallery
    # @gallery.username = current_user.profile.username

    if @gallery.save
      flash[:notice] = 'Success'
      redirect_to galleries_path
    else
      flash[:error] = 'No Luck. ' + @gallery.errors.inspect
      @cities_list = City.list
      @tags_list = Tag.list
      render :action => 'new'
    end
  end

  def edit
    @gallery = Gallery.unscoped.find params[:id]
    authorize! :edit, @gallery
  end

  def update
    @gallery = Gallery.unscoped.find params[:id]
    authorize! :update, @gallery
    if @gallery.update_attributes( params[:gallery].permit! )
      flash[:notice] = 'Success.'
      redirect_to galleries_path
    else
      flash[:error] = 'No Luck. ' + @gallery.errors.messages
      render :action => :edit
    end
  end                           

  def show
    @gallery = Gallery.unscoped.find_by :galleryname => params[:id]
    authorize! :show, @gallery
    @photos = @gallery.photos.unscoped.where({ :is_trash => false })
  end

  def destroy
    @gallery = Gallery.unscoped.find params[:id]
    authorize! :destroy, @gallery
    @gallery.is_trash = true
    @gallery.save
    flash[:notice] = 'Logically deleted gallery.'
    redirect_to galleries_path
  end

  def j_show
    @gallery = Gallery.unscoped.find( params[:id] )
    authorize! :show, @gallery
    respond_to do |format|
      format.json do
        jjj = {}
        jjj[:photos] = @gallery.photos.map do |ph|
          { :thumbnail_url => ph.photo.url( :thumb ),
          :delete_type => 'DELETE',
          :delete_url => photo_path(ph) }
        end
        render :json => jjj
      end
    end
  end

end

