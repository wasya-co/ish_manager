
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
      redirect_to action: :index
    end
  end

  def edit
    @appliance_tmpl = Wco::ApplianceTmpl.find params[:id]
    authorize! :edit, @appliance_tmpl
  end

  def index
    authorize! :index, Wco::ApplianceTmpl
    @appliance_tmpls = Wco::ApplianceTmpl.all
  end

  def update
    @appliance_tmpl = Wco::ApplianceTmpl.find params[:id]
    authorize! :update, @appliance_tmpl
    flag = @appliance_tmpl.update params[:appliance].permit!
    if flag
      flash_notice 'success'
    else
      flash_alert "Cannot update appliance template: #{@appliance_tmpl.errors.full_messages.join(', ')}."
    end
    redirect_to action: :index
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

