
class Manager::FeaturesController < Manager::ManagerController

  before_filter :set_lists
  
  def new
    authorize! :new, ManagerFeature.new
    @city = City.find params[:city_id] unless params[:city_id].blank?
    @site = Site.find params[:site_id] unless params[:site_id].blank?
    @tag = Tag.find params[:tag_id] unless params[:tag_id].blank?
    @feature = Feature.new
  end

  def create
    authorize! :create, ManagerFeature.new

    @feature = Feature.new params[:feature].permit( :name, :subhead, :image_path, :link_path, :partial_name, :photo, :weight,
                                                    :report, :report_id, :gallery, :gallery_id, :video, :video_id
                                                  )
    if params[:city_id]
      @city = City.find params[:city_id]
      @city.features << @feature
      redirect_path = manager_cities_path
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      @site.features << @feature
      redirect_path = manager_sites_path
    end
    if params[:tag_id]
      @tag = Tag.find params[:tag_id]
      @tag.features << @feature
      redirect_path = manager_tags_path
    end

    if (@city && @city.save) || (@site && @site.save) || (@tag && @tag.save)
      flash[:notice] = 'Success.'
      redirect_to redirect_path
    else
      flash[:error] = 'No Luck. ' + ( @city || @site || @tag ).errors.inspect
      render :action => :new
    end
  end

  def edit
    authorize! :edit, ManagerCity.new
    
    if params[:city_id]
      @city = City.find params[:city_id]
      @feature = @city.features.find params[:id]
    end

    if params[:site_id]
      @site = Site.find params[:site_id]
      @feature = @site.features.find params[:id]
    end

    if params[:tag_id]
      @tag = Tag.find params[:tag_id]
      @feature = @tag.features.find params[:id]
    end
   
    if params[:venue_id]
      @venue = Tag.find params[:venue_id]
      @feature = @venue.features.find params[:id]
    end

  end

  def update
    unless params[:city_id].blank?
      @city = City.find params[:city_id] 
      authorize! :update, ManagerCity.new
      @feature = @city.features.find params[:id]
      redirect_path = manager_city_path( @city )
    end
    unless params[:site_id].blank?
      @site = Site.find params[:site_id] 
      authorize! :update, ManagerSite.new
      @feature = @site.features.find params[:id]
      redirect_path = manager_site_path( @site )
    end
    unless params[:tag_id].blank?
      @tag = Tag.find params[:tag_id]
      authorize! :update, ManagerTag.new
      @feature = @tag.features.find params[:id]
      redirect_path = manager_tag_path( @tag )
    end
    
    if @feature.update_attributes params[:feature].permit!
      flash[:notice] = 'Success'
      redirect_to redirect_path
    else
      flash[:error] = 'No Luck. ' + @feature.errors.inspect
      puts! @feature.errors, 'Errors updating feature'
      render :action => :edit_feature
    end    
  end

  def index
    if params[:tag_id]
      @resource = Tag.find params[:tag_id]
    end
    
  end

  def destroy
    if params[:tag_id]
      @resource = Tag.find params[:tag_id]
    elsif params[:city_id]
      @resource = City.find params[:city_id]
    elsif params[:site_id]
      @resource = Site.find params[:site_id]
    end
    @feature = @resource.features.find params[:id]
    if @feature.destroy
      flash[:notice] = :'Success.' 
    else
      flash[:error] = :'No luck.'
    end
    redirect_to request.referrer
  end
  
end

