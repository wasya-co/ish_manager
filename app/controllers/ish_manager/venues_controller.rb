
class IshManager::VenuesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :venues_index, ::Manager
    @venues = Venue.all
    if params[:city_id]
      @resource = @city = City.find params[:city_id]
      @venues = @venues.where( :city => @city )
    end
  end

  def new
    @venue = Venue.new
    @venue.city_id = params[:city_id] if params[:city_id]
    @venue.to_city = 'yes' if params[:city_id]

    authorize! :new, @venue
  end

  def create
    redirect_path = venues_path()
    @venue = Venue.new params[:venue].permit!
    authorize! :create, @venue
    if params[:venue][:to_city] == 'yes'
      redirect_path = city_path( params[:venue][:city_id] )
    end
    if @venue.save
      redirect_to redirect_path, :notice => 'Venue successfully created.'
    else
      #flash[:alert] = @venue.errors.messages
      render :action => :new
    end
  end

  def edit
    @venue = Venue.find params[:id]
    @venue.to_city = params[:from_city]
    authorize! :edit, @venue
  end

  def update

    redirect_path = venues_path()
    redirect_path = city_path( params[:venue][:city_id] ) if params[:venue][:to_city] == 'yes'
    params[:venue][:tag_ids].delete ''
    @resource = @venue = Venue.find params[:id]
    authorize! :update, @venue
    update_profile_pic
    flag = @venue.update_attributes params[:venue].permit!
    if flag
      flash[:notice] = 'updated venue'
      redirect_to redirect_path
    else
      flash[:alert] = "No luck: #{@venue.errors.messages}"
      render :action => :edit
    end
  end

  def show
    @venue = Venue.find params[:id]
    authorize! :show, @venue
    redirect_to :action => :edit, :id => @venue.id
  end

  def destroy
    @venue = Venue.unscoped.find params[:id]
    venue_name = @venue.name
    authorize! :delete, @venue
    redirect_path = venues_path
    redirect_path = city_path( @venue.city_id ) if params[:from_city] == 'yes'
    if @venue.destroy
      flash[:notice] = "Deleted venue #{venue_name}"
    else
      flash[:alert] = "Cannot delete venue: #{@venue.errors.messages}"
    end
    redirect_to redirect_path
  end

end


