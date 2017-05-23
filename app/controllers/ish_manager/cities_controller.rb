class IshManager::CitiesController < IshManager::ApplicationController
  before_filter :set_lists, :only => [ :new_newsitem, :create_newsitem ]
  before_filter :sett_city, :only => [ :show, :edit ]

  def index
    authorize! :index, ManagerCity.new
    @cities = City.all
    @city = City.new
    @photo = Photo.new
  end
  
  def show
    authorize! :show, @city
  end
  
  def new
    authorize! :new, ManagerCity.new
    @city = City.new
    @photo = Photo.new
  end

  def create
    authorize! :create, ManagerCity.new
    @city = City.new params[:city].permit!
    if @city.save
      flash[:notice] = 'Success'
      redirect_to manager_cities_path
    else
      flash[:error] = 'No Luck'
      render :action => :new
    end
  end

  def edit
    authorize! :edit, @city
  end
  
  def update
    authorize! :update, ManagerCity.new
    @city = City.find( params[:id] )
    @city.update_attributes params[:city].permit!
    if @city.save
      flash[:notice] = 'Success'
      redirect_to edit_manager_city_path @city.id
    else
      flash[:error] = 'No Luck. ' + @city.errors.inspect
      @newsitems = @city.newsitems.all.page( params[:newsitems_page] )
      @features = @city.features.all.page( params[:features_page] )
      @photo = Photo.new
      render :action => :edit
    end
  end

  def change_profile_pic
    authorize! :change_profile_pic, ManagerCity.new
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
    redirect_to manager_cities_path
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
