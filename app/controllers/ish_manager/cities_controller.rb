class IshManager::CitiesController < IshManager::ApplicationController
  before_action :set_lists, :only => [ :new_newsitem, :create_newsitem ]
  before_action :sett_city, :only => [ :show, :edit ]

  def index
    authorize! :cities_index, Manager
    @cities = City.all
    @city = City.new
    @photo = Photo.new
  end
  
  def show
    authorize! :show, @city
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
      flash[:error] = 'No Luck'
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
    if @city.save
      flash[:notice] = 'Success'
      redirect_to edit_city_path @city.id
    else
      flash[:error] = 'No Luck. ' + @city.errors.inspect
      @newsitems = @city.newsitems.all.page( params[:newsitems_page] )
      @features = @city.features.all.page( params[:features_page] )
      @photo = Photo.new
      render :action => :edit
    end
  end

  def change_profile_pic
    authorize! :change_profile_pic, City
    @city = City.find params[:id]
    @photo = Photo.new params[:photo]
    @photo.user = @current_user
    flag = @photo.save
    @city.profile_photo = @photo
    flagg = @city.save
    if flag && flagg
      flash[:notice] = 'Success'
    else
      flash[:error] = "No Luck. #{@photo.errors.inspect} #{@city.errors.inspect}"
    end
    redirect_to cities_path
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
