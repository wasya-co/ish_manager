
class ::IshManager::LeadsetsController < IshManager::ApplicationController

  before_action :set_lists

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

  def destroy
    puts! params, 'params'

    leadsets = Leadset.find( params[:leadset_ids] )
    @results = []
    leadsets.each do |leadset|
      @results.push leadset.discard
    end
    flash[:notice] = "Discard outcome: #{@results.inspect}."
    redirect_to action: 'index'
  end

  def edit
    @leadset = Leadset.find params[:id]
    authorize! :edit, @leadset
  end

  def index
    authorize! :index, Leadset
    @leadsets = Leadset.all.kept # where( :profile => @current_profile, :is_trash => false )
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

  ##
  ## private
  ##
  private

  def set_lists
    super
    @tags_list = WpTag.all.map { |t| [ t.name, t.id ] }
    @leads_list = Lead.all.map { |lead| [ lead.email, lead.id ] }
    @templates_list = Ish::EmailTemplate.all.map { |t| [ t.slug, t.id ] }
  end

end
