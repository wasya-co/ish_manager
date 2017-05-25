
class Manager::NewsitemsController < Manager::ManagerController

  def new
    authorize! :new, ManagerNewsitem.new
    @newsitem = Newsitem.new
    if params[:city_id]
      @city = City.find params[:city_id]
      @newsitem.city = @city
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      @newsitem.site = @site
    end
  end

  def create
    authorize! :create, ManagerNewsitem.new

    n = Newsitem.new params[:newsitem].permit!
    n.report  = Report.find  params[:newsitem][:report_id]  unless params[:newsitem][:report_id].blank?
    n.gallery = Gallery.find params[:newsitem][:gallery_id] unless params[:newsitem][:gallery_id].blank?
    n.photo   = Photo.find   params[:newsitem][:photo_id]   unless params[:newsitem][:photo_id].blank?
    n.descr   = params[:newsitem][:descr]

    if params[:city_id]
      @city = City.find params[:city_id]
      @city.newsitems << n
      flag = @city.save
      if flag
        url = edit_manager_city_path( @city.id )
      else
        error = 'No Luck. ' + @city.errors.inspect
      end
    end
    
    if params[:site_id]
      @site = Site.find params[:site_id]
      @site.newsitems << n
      flag = @site.save
      if flag
        url = edit_manager_site_path( @site.id )
      else
        error = 'No Luck. ' + @site.errors.inspect
      end
    end

    if flag
      flash[:notice] = 'Success'
      redirect_to url
    else
      flash[:error] = error
      render :action => :new
    end
  end
  
  def show
  end

  def index
  end

  def destroy
    if params[:city_id]
      flag = City.find( params[:city_id] ).newsitems.find( params[:id] ).destroy
      url = edit_manager_city_path( params[:city_id] )
    end
    if params[:site_id]
      site = Site.find( params[:site_id] )
      flag = site.newsitems.find( params[:id] ).destroy
      url = edit_manager_site_path( params[:site_id] )
    end

    flash[:notice] = "Success? #{flag}"
    redirect_to url
  end

  def update
    if params[:site_id]
      @site = Site.find params[:site_id]
      @site.touch
      @newsitem = @site.newsitems.find params[:id]
      url = edit_manager_site_path( @site )
    end
    if params[:city_id]
      @city = City.find params[:city_id]
      @newsitem = @city.newsitems.find params[:id]
      url = edit_manager_city_path( @city )
    end
    flag = @newsitem.update_attributes params[:newsitem].permit!
    
    if flag
      flash[:notice] = 'Success'
    else
      flash[:error] = "No Luck: #{@newsitem.errors.messages}"
    end

    redirect_to url
  end
  
  def edit
    if params[:site_id]
      @site = Site.find params[:site_id]
      @newsitem = @site.newsitems.find( params[:id] )
    end
    if params[:city_id]
      @city = City.find params[:city_id]
      @newsitem = @city.newsitems.find( params[:id] )
    end
  end

end

