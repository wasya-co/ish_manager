class IshManager::NewsitemsController < IshManager::ApplicationController
  before_action :set_lists

  ## Alphabetized : )

  def create
    @newsitem = Newsitem.new params[:newsitem].permit!
    @resource ||= City.find params[:city_id]              if params[:city_id]
    @resource ||= City.find params[:newsitem][:city_id]   if !params[:newsitem][:city_id].blank? # blank? required
    @resource ||= Site.find params[:site_id]              if params[:site_id]
    @resource ||= Site.find params[:newsitem][:site_id]   if !params[:newsitem][:site_id].blank?
    @resource ||= Tag.find params[:tag_id]                if params[:tag_id]
    @resource ||= Tag.find params[:newsitem][:tag_id]     if !params[:newsitem][:tag_id].blank?
    @resource ||= Ish::UserProfile.find params[:newsitem][:user_profile_id] if !params[:newsitem][:user_profile_id].blank?
    @resource ||= ::Gameui::Map.find params[:newsitem][:map_id] if !params[:newsitem][:map_id].blank?
    @resource.newsitems << @newsitem
    @resource.touch

    authorize! :create_newsitem, @resource

    if params[:photo]
      photo = Photo.create( :photo => params[:photo],
        :user_profile => current_user.profile,
        descr: params[:descr],
        subhead: params[:subhead] )
      @newsitem.photo = photo
    end

    url = case @resource.class.name
    when "City"
      edit_city_path( @resource.id )
    when "Ish::UserProfile"
      user_profiles_path
    when "Site"
      edit_site_path( @resource.id )
    when "Tag"
      @resource.site.touch
      tag_path( @resource.id )
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
    @newsitem = Newsitem.find params[:id]
    authorize! :destroy, @newsitem

    if @newsitem.destroy
      # City.find(@newsitem.city_id).touch if @newsitem.city_id
      # Site.find(@newsitem.site_id).touch if @newsitem.site_id
      Tag.find(@newsitem.tag_id).touch if @newsitem.tag_id
      Map.find(@newsitem.map_id).touch if @newsitem.map_id

      flash[:notice] = "Destroyed the newsitem."
    else
      flash[:alert] = "Cannot destroy the newsitem: #{@newsitem.errors.full_messages}."
    end

    redirect_to request.referrer ? request.referrer : '/'
  end

  def edit
    @newsitem = Newsitem.find( params[:id] )
    authorize! :edit, @newsitem

    ## @TODO: what on earth is this?
    out = Gallery.unscoped.where( :is_trash => false, :user_profile => current_user.profile ).order_by( :created_at => :desc )
    @galleries_list = [['', nil]] + out.map { |item| [ "#{item.created_at.strftime('%Y%m%d')} #{item.name}", item.id ] }

  end

  def index
    @resource = Site.find( params[:site_id] ) if params[:site_id]
    @resource = City.find( params[:site_id] ) if params[:city_id]

    authorize! :newsitems_index, @resource
    @newsitems = @resource.newsitems
  end

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
    if params[:tag_id]
      @tag = Tag.unscoped.find params[:tag_id]
      @newsitem.tag = @tag
    end
    authorize! :new, @newsitem
  end

  def update
    @newsitem = Newsitem.find params[:id]
    authorize! :update, @newsitem

    ## @TODO: re-add site management here, probably.

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

    flag = @newsitem.update_attributes params[:newsitem].permit!
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No Luck: #{@newsitem.errors.messages}"
    end

    redirect_to edit_newsitem_path(@newsitem)
  end

end

