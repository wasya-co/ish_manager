
class IshManager::NewsitemsController < IshManager::ApplicationController

  before_action :set_lists

  def new
    @newsitem = Newsitem.new
    if params[:city_id]
      @city = City.find params[:city_id]
      @newsitem.city = @city
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      @newsitem.site = @site
    end
    authorize! :new, @newsitem
  end

  def create
    n = Newsitem.new params[:newsitem].permit!
    authorize! :create, n

    if params[:city_id]
      @city = City.find params[:city_id]
      @city.newsitems << n
      flag = @city.save
      if flag
        url = edit_city_path( @city.id )
      else
        error = 'No Luck. ' + @city.errors.inspect
      end
    end
    
    if params[:site_id]
      @site = Site.find params[:site_id]
      @site.newsitems << n
      flag = @site.save
      if flag
        url = edit_site_path( @site.id )
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
  
  def destroy
    authorize! :destroy, Newsitem
    if params[:city_id]
      flag = City.find( params[:city_id] ).newsitems.find( params[:id] ).destroy
      url = edit_city_path( params[:city_id] )
    end
    if params[:site_id]
      site = Site.find( params[:site_id] )
      flag = site.newsitems.find( params[:id] ).destroy
      url = edit_site_path( params[:site_id] )
    end

    flash[:notice] = "Success? #{flag}"
    redirect_to url
  end

  def update
    if params[:site_id]
      @site = Site.find params[:site_id]
      @site.touch
      @newsitem = @site.newsitems.find params[:id]
      url = edit_site_path( @site )
    end
    if params[:city_id]
      @city = City.find params[:city_id]
      @newsitem = @city.newsitems.find params[:id]
      url = edit_city_path( @city )
    end
    authorize! :update, @newsitem
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
    authorize! :edit, @newsitem
  end

  private

  def set_lists
    @videos_list = Video.list
  end

end

