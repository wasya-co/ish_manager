class IshManager::CitiesController < IshManager::ApplicationController
  before_action :set_lists, :only => [ :new_newsitem, :create_newsitem ]
  before_action :sett_city, :only => [ :show, :edit ]

  def index
    authorize! :index, City
    @cities = City.unscoped
    @city = City.new
    @photo = Photo.new
  end
  
  def show
    authorize! :show, @city
    @videos = @city.videos.page( params[:videos_page] ).per( Video::PER_PAGE )
    @venues = @city.venues.page( params[:venues_page] ).per( Venue::PER_PAGE )
    @galleries = @city.galleries.page( params[:galleries_page] ).per( Gallery::PER_PAGE )
    @reports = @city.reports.page( params[:reports_page] ).per( Report::PER_PAGE )
    @newsitems = @city.newsitems.page( params[:newsitems_page] ).per( Newsitem::PER_PAGE )
    if params[:q]
      @venues = @venues.where({ :name => /#{params[:q]}/i })
    end
  end
  
  def new
    @city = City.new
    authorize! :new, City

    @photo = Photo.new
  end

  def create
    @city = City.new params[:city].permit!
    authorize! :create, @city

    if @city.save
      flash[:notice] = 'Success'
      redirect_to cities_path
    else
      flash[:alert] = 'No Luck'
      render :action => :new
    end
  end

  def edit
    authorize! :edit, @city
  end
  
  def update
    @city = City.find( params[:id] )
    authorize! :update, @city
    @city.update_attributes params[:city].permit!
    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      @city.profile_photo = photo
    end
    if @city.save
      ::IshModels::CacheKey.one.update_attributes( :cities => Time.now, :feature_cities => Time.now )
      flash[:notice] = 'Success'
      redirect_to edit_city_path @city.id
    else
      flash[:alert] = 'No Luck. ' + @city.errors.inspect
      @newsitems = @city.newsitems.all.page( params[:newsitems_page] )
      @features = @city.features.all.page( params[:features_page] )
      @photo = Photo.new
      render :action => :edit
    end
  end

  def change_profile_pic
    authorize! :update, City
    @city = City.find params[:id]
    @photo = Photo.new params[:photo]
    @photo.user = @current_user
    flag = @photo.save
    @city.profile_photo = @photo
    flagg = @city.save
    if flag && flagg
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No Luck. #{@photo.errors.messages} #{@city.errors.messages}"
    end
    redirect_to cities_path
  end

  def delete
    c = City.find params[:id]
    if c.delete
      render
    else
      flash[:error] = c.errors.messages
    end
  end

  private

  def sett_city
    @city = City.find params[:id]
    @photo = Photo.new
  end

  def set_lists
    @list_reports = Report.all.list
    @list_galleries = Gallery.all.list
    @list_users = [['', nil]] + User.all.order_by( :name => :asc ).map { |u| [u.username, u.username] }
  end

end
