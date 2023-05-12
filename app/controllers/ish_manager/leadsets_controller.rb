
class ::IshManager::LeadsetsController < IshManager::ApplicationController

  before_action :set_lists

  ## alphabetized : )

  def create
    @leadset = Leadset.new params[:leadset].permit!
    authorize! :create, @leadset
    if @leadset.save
      flash[:notice] = "created leadset"
    else
      flash[:alert] = "Cannot create leadset: #{@leadset.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def destroy
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
    @leadsets = Leadset.all.kept.includes(:leads)
    if params[:q].present?
      @leadsets = @leadsets.where(" company_url LIKE ? ", "%#{params[:q]}%" )
    end
    @leadsets = @leadsets.page( params[:leadsets_page] ).per( current_profile.per_page )
  end

  def new
    @new_leadset = Leadset.new
    authorize! :new, @new_leadset
  end

  def show
    @leadset = Leadset.find params[:id]
    authorize! :show, @leadset
    @email_contexts = {}
    @leadset.employees.each do |lead|
      @email_contexts[lead.email] = lead.email_contexts
    end
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
