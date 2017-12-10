
class IshManager::VenuesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :venues_index, ::Manager
    @venues = Venue.all
  end

  def new
    @venue = Venue.new
    authorize! :new, @venue
  end

  def create
    @venue = Venue.new params[:venue].permit!
    authorize! :create, @venue
    if @venue.save
      redirect_to :action => :index
    else
      flash[:alert] = @venue.errors.messages
      render :action => :new
    end
  end

  def edit
    @venue = Venue.find params[:id]
    authorize! :edit, @venue
  end

  def update
    @venue = Venue.find params[:id]
    authorize! :update, @venue

    flag = @venue.update_attributes params[:venue].permit!
    if flag
      flash[:notice] = 'updated venue'
      redirect_to :action => :index
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

end


