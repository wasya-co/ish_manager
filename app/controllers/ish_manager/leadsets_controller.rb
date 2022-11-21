
class ::IshManager::LeadsetsController < IshManager::ApplicationController

  ## alphabetized : )

  def create
    @leadset = Leadset.new params[:leadset].permit!
    @leadset.profile = @current_profile
    authorize! :create, @leadset
    if @leadset.save
      flash[:notice] = "created leadset"
    else
      flash[:alert] = "Cannot create leadset: #{@leadset.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def edit
    @leadset = Leadset.find params[:id]
    authorize! :edit, @leadset
  end

  def index
    authorize! :index, Leadset
    @leadsets = Leadset.all # where( :profile => @current_profile, :is_trash => false )
    # if params[:is_done]
    #   @leadsets = @leadsets.where( :is_done => true )
    # else
    #   @leadsets = @leadsets.where( :is_done => false )
    # end
  end

  def new
    @new_leadset = Leadset.new
    authorize! :new, @new_leadset
  end

  def show
    authorize! :redirect, IshManager::Ability
    redirect_to :action => :edit, :id => params[:id]
  end

  def update
    @leadset = Leadset.find params[:id]
    authorize! :update, @leadset
    if @leadset.update_attributes params[:leadset].permit!
      flash[:notice] = 'Successfully updated leadset.'
    else
      flash[:alert] = "Cannot update leadset: #{@leadset.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end
