
class IshManager::FeaturesController < IshManager::ApplicationController

  before_action :set_lists
  
  def new
    if params[:city_id]
      @city = City.find params[:city_id]
      authorize! :new_feature, @city
    elsif params[:site_id]
      @site = Site.find params[:site_id]
      authorize! :new_feature, @site
    elsif params[:tag_id]
      @tag = Tag.find params[:tag_id]
      authorize! :new_feature, @tag
    end

    @feature = Feature.new
  end

  def create
    @feature = Feature.new params[:feature].permit!

    if params[:city_id]
      @city = City.find params[:city_id]
      authorize! :create_feature, @city
      @city.features << @feature
      @city.touch
      redirect_path = cities_path
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      authorize! :create_feature, @site
      @site.features << @feature
      @site.touch
      redirect_path = sites_path
    end
    if params[:tag_id]
      @tag = Tag.find params[:tag_id]
      authorize! :create_feature, @tag
      @tag.features << @feature
      @tag.touch
      redirect_path = tags_path
    end

    if (@city && @city.save) || (@site && @site.save) || (@tag && @tag.save)
      flash[:notice] = 'Success.'
      redirect_to redirect_path
    else
      flash[:alert] = "No luck: #{pp_errors @feature.errors.messages}"
      render :action => :new
    end
  end

  def edit
    if params[:city_id]
      @city = City.find params[:city_id]
      @feature = @city.features.find params[:id]
      authorize! :edit_feature, @city
    end

    if params[:site_id]
      @site = Site.find params[:site_id]
      @feature = @site.features.find params[:id]
      authorize! :edit_feature, @site
    end

    if params[:tag_id]
      @tag = Tag.find params[:tag_id]
      @feature = @tag.features.find params[:id]
      authorize! :edit_feature, @tag
    end
   
    if params[:venue_id]
      @venue = Tag.find params[:venue_id]
      @feature = @venue.features.find params[:id]
      authorize! :edit_feature, @venue
    end

  end

  def update
    unless params[:city_id].blank?
      @city = City.find params[:city_id] 
      authorize! :update_feature, @city
      @feature = @city.features.find params[:id]
      redirect_path = city_path( @city )
    end
    unless params[:site_id].blank?
      @site = Site.find params[:site_id] 
      authorize! :update_feature, @site
      @feature = @site.features.find params[:id]
      redirect_path = site_path( @site )
    end
    unless params[:tag_id].blank?
      @tag = Tag.find params[:tag_id]
      authorize! :update_feature, @tag
      @feature = @tag.features.find params[:id]
      redirect_path = tag_path( @tag )
    end
    
    if @feature.update_attributes params[:feature].permit!
      @city.touch if @city
      @site.touch if @site
      @tag.touch  if @tag

      flash[:notice] = 'updated feature'
      redirect_to redirect_path
    else
      flash[:error] = 'No Luck. ' + @feature.errors.messages
      render :action => :edit
    end    
  end

=begin
  def index
    if params[:tag_id]
      @resource = Tag.find params[:tag_id]
    end
    
  end
=end

  def destroy
    if params[:tag_id]
      @resource = Tag.find params[:tag_id]
    elsif params[:city_id]
      @resource = City.find params[:city_id]
    elsif params[:site_id]
      @resource = Site.find params[:site_id]
    end
    authorize! :destroy_feature, @resource
    @feature = @resource.features.find params[:id]
    if @feature.destroy
      @resource.touch
      flash[:notice] = :'Success.' 
    else
      flash[:error] = :'No luck.'
    end
    redirect_to request.referrer
  end
  
end

