
class IshManager::NewsitemsController < IshManager::ApplicationController

  before_action :set_lists

  def new
    @newsitem = Newsitem.new
    @sites = Site.list
    @cities = City.list
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
    @newsitem = Newsitem.new params[:newsitem].permit!
    @resource = City.find params[:city_id] if params[:city_id]
    @resource = City.find params[:newsitem][:city_id] if !params[:newsitem][:city_id].blank?
    @resource = Site.find params[:site_id] if params[:site_id]
    @resource = Site.find params[:newsitem][:site_id] if !params[:newsitem][:site_id].blank?
    @resource.newsitems << @newsitem

    authorize! :create_newsitem, @resource

    if params[:photo]
      photo = Photo.create :photo => params[:photo], :user_profile => current_user.profile
      @newsitem.photo = photo
    end

    flag = @newsitem.save && @resource.save
    if flag
      @resource.touch
    else
      error = 'No Luck. ' + @newsitem.errors.messages.to_s  + " :: " + photo.errors.messages.to_s
    end
    url = params[:city_id] ? edit_city_path( @resource.id ) : edit_site_path( @resource.id )
    
    if flag
      flash[:notice] = 'Success'
      redirect_to url
    else
      flash[:alert] = error
      @sites = Site.list
      @cities = City.list

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
    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      photo.user_profile = current_user.profile
      @newsitem.photo = photo
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

  def index
    @resource = Site.find( params[:site_id] ) if params[:site_id]
    @resource = City.find( params[:site_id] ) if params[:city_id]
    authorize! :newsitems_index, @resource
    @newsitems = @resource.newsitems
  end

  private

  def set_lists
    @videos_list    = Video.list
    @galleries_list = Gallery.list
    @reports_list   = Report.list
  end

end

