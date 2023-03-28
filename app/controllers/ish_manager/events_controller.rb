
class IshManager::EventsController < ::IshManager::ApplicationController

  def create
    authorize! :manage, Ish::Event
    @event = Ish::Event.create( params[:event].permit! )
    if @event.persisted?
      flash[:notice] = "Success."
      redirect_to action: 'index'
    else
      flash[:alert] = "No luck: #{@event.errors.full_messages.join(', ')}."
      render 'new'
    end
  end

  def edit
    authorize! :manage, Ish::Event
    @event = Ish::Event.find params[:id]
  end

  def index
    authorize! :manage, Ish::Event
    @events = Ish::Event.all
    if params[:q]
      @events = @events.where({ :name => /#{params[:q]}/i })
    end
  end

  def new
    authorize! :manage, Ish::Event
    @event = Ish::Event.new
  end

  def show
    authorize! :manage, Ish::Event
    @event = Ish::Event.find params[:id]
  end

  def update
    authorize! :manage, Ish::Event
    @event = Ish::Event.find params[:id]
    @event.update_attributes( params[:event].permit! )
    if @event.persisted?
      flash[:notice] = "Success."
      redirect_to action: 'index'
    else
      flash[:alert] = "No luck: #{@event.errors.full_messages.join(', ')}."
      render 'edit'
    end
  end

end
