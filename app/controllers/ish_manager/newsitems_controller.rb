class IshManager::NewsitemsController < IshManager::ApplicationController
  before_action :set_lists

  def new
    @newsitem = Newsitem.new
    @sites    = Site.list
    @cities   = City.list
    @tags     = Tag.list
    if params[:city_id]
      @city = City.find params[:city_id]
      @newsitem.city = @city
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      @newsitem.site = @site
    end
    if params[:tag_id]
      @tag = Tag.unscoped.find params[:tag_id]
      @newsitem.tag = @tag
    end
    authorize! :new, @newsitem
  end

  def create
    @newsitem = Newsitem.new params[:newsitem].permit!
    @resource = City.find params[:city_id]              if params[:city_id]
    @resource = City.find params[:newsitem][:city_id]   if !params[:newsitem][:city_id].blank?
    @resource = Site.find params[:site_id]              if params[:site_id]
    @resource = Site.find params[:newsitem][:site_id]   if !params[:newsitem][:site_id].blank?
    @resource = Tag.find params[:tag_id]                if params[:tag_id]
    @resource = Tag.find params[:newsitem][:tag_id]     if !params[:newsitem][:tag_id].blank?

    @resource = IshModels::UserProfile.find params[:newsitem][:user_profile_id] if !params[:newsitem][:user_profile_id].blank?
    @resource.newsitems << @newsitem

    authorize! :create_newsitem, @resource

    if params[:photo]
      photo = Photo.create :photo => params[:photo], :user_profile => current_user.profile
      @newsitem.photo = photo
    end

    url = case @resource.class.name
    when "City"
      edit_city_path( @resouce.id )
    when "Tag"
      @resource.site.touch
      tag_path( @resource.id )
    when "Site"
      edit_site_path( @resource.id )
    when "IshModels::UserProfile"
      user_profiles_path
    else
      root_path
    end
    
    flag = @newsitem.save && @resource.save
    if flag
      @resource.touch
      flash[:notice] = 'Success'
      redirect_to url
    else
      error = 'No Luck. ' + @newsitem.errors.messages.to_s  + " :: " + photo.errors.messages.to_s
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
    if profile_id = params[:user_profile_id]
      profile = IshModels::UserProfile.find profile_id
      flag = profile.newsitems.find( params[:id] ).destroy
      url = profile_path( profile_id )
    end
    if params[:site_id]
      site = Site.find( params[:site_id] )
      flag = site.newsitems.find( params[:id] ).destroy
      if flag
        site.touch
      end
      url = edit_site_path( params[:site_id] )
    end
    if params[:tag_id]
      tag = Tag.find( params[:tag_id] )
      flag = tag.newsitems.find( params[:id] ).destroy
      url = tag_path( params[:tag_id] )
    end

    flash[:notice] = "Success? #{flag.inspect}"
    redirect_to request.referrer ? request.referrer : '/'
  end

  def update
    if params[:site_id] || params[:newsitem][:site_id]
      if params[:site_id]
        @site = Site.find params[:site_id]
      end
      if params[:newsitem][:site_id]
        @site = Site.find params[:newsitem][:site_id]
      end
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
      flash[:alert] = "No Luck: #{@newsitem.errors.messages}"
    end

    redirect_to url
  end
  
  def edit
    out = Gallery.unscoped.where( :is_trash => false, :user_profile => current_user.profile ).order_by( :created_at => :desc )
    @galleries_list = [['', nil]] + out.map { |item| [ "#{item.created_at.strftime('%Y%m%d')} #{item.name}", item.id ] }

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
    @sites_list     = Site.list
    @cities_list    = City.list
    @tags_list      = Tag.list
    @user_profiles_list = IshModels::UserProfile.list
  end

end

