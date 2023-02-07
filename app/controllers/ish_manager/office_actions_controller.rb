
class ::IshManager::OfficeActionsController < IshManager::ApplicationController

  before_action :set_lists

  ## alphabetized : )

  def create
    # @lead = ::Lead.new params[:lead].permit!
    # authorize! :create, @lead
    # if @lead.save
    #   flash[:notice] = "created lead"
    # else
    #   flash[:alert] = "Cannot create lead: #{@lead.errors.messages}"
    # end
    # redirect_to :action => 'index'
  end

  def edit
    # @lead = ::Lead.find params[:id]
    # authorize! :edit, @lead
  end

  def index
    @actions = Office::Action.active
    @new_office_action = Office::Action.new
    authorize! :index, @new_office_action
  end

  def new
    # @new_lead = ::Lead.new
    # authorize! :new, @new_lead
  end

  def show
    # authorize! :redirect, IshManager::Ability
    # redirect_to :action => :edit, :id => params[:id]
  end

  def update
    # @lead = ::Lead.find params[:id]
    # authorize! :update, @lead
    # if @lead.update_attributes params[:lead].permit!
    #   flash[:notice] = 'Successfully updated lead.'
    # else
    #   flash[:alert] = "Cannot update lead: #{@lead.errors.messages}"
    # end
    # redirect_to :action => 'index'
  end

  private

  def set_lists
    super
    @leadsets_list = [ [nil,nil] ] + ::Leadset.all.map { |k| [ k.name, k.id ] }
    @email_campaigns_list = [ [nil,nil] ] + Ish::EmailContext.unsent_campaigns.map { |k| [ k.slug, k.id ] }
  end

end
