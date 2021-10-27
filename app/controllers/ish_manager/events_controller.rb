
class IshManager::EventsController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :index, ::Event
    @events = Event.all
    if params[:city_id]
      @resource = City.find( params[:city_id] )
      @events = @resource.events
    end
  end

  def new
    @event = Event.new
    authorize! :new, @event
  end

  def create
    @event = Event.new params[:event].permit!
    authorize! :create, @event
    if @event.save
      @event.city.touch
      redirect_to :action => :index
    else
      flash[:alert] = @event.errors.messages
      render :action => :new
    end
  end

  def edit
    @event = Event.find params[:id]
    authorize! :edit, @event
  end

  def update
    @event = Event.find params[:id]
    authorize! :update, @event

    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      @event.profile_photo = photo
    end

    flag = @event.update_attributes params[:event].permit!
    if flag
      @event.city.touch
      flash[:notice] = 'updated event'
      redirect_to :action => :index
    else
      flash[:alert] = "No luck: #{@event.errors.messages}"
      render :action => :edit
    end
  end

  def show
    @event = Event.find params[:id]
    authorize! :show, @event
    redirect_to :action => :edit, :id => @event.id
  end

end


