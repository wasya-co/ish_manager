class IshManager::SitesController < IshManager::ApplicationController
  
  def index
    authorize! :sites_index, ::Manager
    @sites = Site.where( :is_trash => false ).order_by( :domainname => :desc, :lang => :desc )
  end

  # not trash
  def trash
    @sites = Site.unscoped.where( :is_trash => true ).order_by( :domainname => :desc, :lang => :desc )
    render :action => :index
  end

  def show
    @site = Site.unscoped.find params[:id]
    authorize! :show, @site
    @galleries = @site.galleries.unscoped.where({ :is_trash => false }).page( params[:galleries_page] ).per( 10 )
    @reports = @site.reports.unscoped.where({ :is_trash => false }).page( params[:reports_page] ).per( 10 )
    @videos = @site.videos.page( params[:videos_page] ).per( 5 )
    @tags = @site.tags.page( params[:tags_page] ).per( 100 )
    @features = @site.features.page( params[:features_page] ).per( 9 )
    @newsitems = @site.newsitems.page( params[:newsitems_page] ).per( 10 )
  end

  def edit
    @site = Site.find params[:id]
    authorize! :update, @site
  end
  
  def new
    authorize! :new, Site.new
    @site = Site.new
  end

  def create
    authorize! :create, Site.new
    @site = Site.new params[:site].permit!
    if @site.save
      flash[:notice] = 'Success'
    else
      flash[:error] = 'No Luck. ' + @site.errors.inspect
    end
    redirect_to sites_path
  end

  def update
    @site = Site.unscoped.find params[:id]
    authorize! :update, @site
    
    if @site.update_attributes params[:site].permit!
      flash[:notice] = 'Success'
    else
      flash[:error] = 'No Luck'
    end
    redirect_to sites_path
  end

  def newsitem_delete    
    @site = Site.find params[:site_id]
    authorize! :update, @site  
    n = @site.newsitems.find( params[:newsitem_id] )
    n.delete
    @site.save
    flash[:notice] = 'Probably successfully deleted a newsitem.'
    redirect_to site_path( @site.id )
  end

end

