class IshManager::NewsitemsController < IshManager::ApplicationController
  before_action :set_lists

  ## Alphabetized : )

  def create
    @newsitem = Newsitem.new params[:newsitem].permit!
    @resource ||= Ish::UserProfile.find params[:newsitem][:user_profile_id] if !params[:newsitem][:user_profile_id].blank?
    @resource ||= ::Gameui::Map.find params[:newsitem][:map_id] if !params[:newsitem][:map_id].blank?
    @resource.newsitems << @newsitem
    @resource.touch

    authorize! :create_newsitem, @resource

    if params[:photo]
      photo = Photo.create( :photo => params[:photo],
        :user_profile => @current_profile,
        descr: params[:descr],
        subhead: params[:subhead] )
      @newsitem.photo = photo
    end

    url = case @resource.class.name
    when "Ish::UserProfile"
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
      render :action => :new
    end
  end

  def destroy
    @newsitem = Newsitem.find params[:id]
    authorize! :destroy, @newsitem

    if @newsitem.destroy
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
    out = Gallery.unscoped.where( :is_trash => false, :user_profile => @current_profile ).order_by( :created_at => :desc )
    @galleries_list = [['', nil]] + out.map { |item| [ "#{item.created_at.strftime('%Y%m%d')} #{item.name}", item.id ] }

  end

  def index
    authorize! :newsitems_index, @resource
    @newsitems = @resource.newsitems
  end

  def new

    @newsitem = Newsitem.new

    authorize! :new, @newsitem
  end

  def update
    @newsitem = Newsitem.find params[:id]
    authorize! :update, @newsitem

    ## @TODO: re-add site management here, probably.

    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      photo.user_profile = @current_profile
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

