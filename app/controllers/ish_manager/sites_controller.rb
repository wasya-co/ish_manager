class IshManager::SitesController < IshManager::ApplicationController
  
  def index
    authorize! :sites_index, ::Manager
    @site_groups = Site.where( :is_trash => false ).order_by( :lang => :desc ).group_by {|s|s.domain}
  end

  # not trash
  def trash
    @sites = Site.unscoped.where( :is_trash => true ).order_by( :domainname => :desc, :lang => :desc )
    render :action => :index
  end

  def show
    @site = Site.unscoped.find params[:id]
    authorize! :show, @site
    @galleries = @site.galleries.page( params[:galleries_page] ).per( 10 )
    @reports = @site.reports.page( params[:reports_page] ).per( 10 )
    @videos = @site.videos.page( params[:videos_page] ).per( 5 )
    @tags = Tag.where( :site_id => @site.id, :parent_tag_id => nil ).page( params[:tags_page] ).per( 100 )
    @features = @site.features.limit( @site.n_features ) # page( params[:features_page] ).per( 9 )
    @newsitems = @site.newsitems.page( params[:newsitems_page] ).per( @site.newsitems_per_page )
  end

  def edit
    @site = Site.unscoped.find params[:id]
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
      flash[:alert] = 'No Luck. ' + @site.errors.inspect
    end
    redirect_to sites_path
  end

  def update
    @site = Site.unscoped.find params[:id]
    authorize! :update, @site
    
    params[:site][:private_user_emails] = params[:site][:private_user_emails].gsub(/\s+/m, ' ').strip.split(" ")

    if @site.update_attributes params[:site].permit!
      flash[:notice] = 'Success'
    else
      flash[:alert] = 'No Luck'
    end
    redirect_to sites_path
  end

  def newsitem_delete    
    @site = Site.find params[:site_id]
    authorize! :update, @site  
    n = @site.newsitems.find( params[:newsitem_id] )
    n.delete
    @site.touch
    @site.save
    flash[:notice] = 'Probably successfully deleted a newsitem.'
    redirect_to site_path( @site.id )
  end

  def reports
    @site = Site.find params[:site_id]
    authorize! :reports_index, @site
    @reports = @site.reports.page( params[:reports_page] )
    render 'ish_manager/reports/index'
  end

  def galleries
    @site = Site.find params[:site_id]
    authorize! :galleries_index, @site
    @galleries = @site.galleries.page( params[:galleries_page] )
  end

  #
  # private
  #
  private

end

