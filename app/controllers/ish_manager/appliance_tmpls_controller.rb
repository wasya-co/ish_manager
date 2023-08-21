
class ::IshManager::ApplianceTmplsController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @appliance_tmpl = Wco::ApplianceTmpl.new params[:appliance].permit!
    authorize! :create, @appliance_tmpl

    flag = @appliance_tmpl.save
    if flag
      flash[:notice] = 'Success.'
      redirect_to action: :index
    else
      flash[:alert] = "Cannot create appliance tmplate: #{@appliance_tmpl.errors.full_messages.join(', ')}."
      render action: :index
    end
  end

  def index
    authorize! :index, Wco::ApplianceTmpl
    @appliance_tmpls = Wco::ApplianceTmpl.all
  end

  ##
  ## private
  ##
  private

  def set_lists
    super
    @new_appliance_tmpl = Wco::ApplianceTmpl.new
  end

end

