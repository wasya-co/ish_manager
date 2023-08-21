
class ::IshManager::AppliancesController < IshManager::ApplicationController

  before_action :set_lists, only: %i| edit update |

  # def create
  #   @appliance_tmpl = Wco::ApplianceTmpl.new params[:appliance].permit!
  #   authorize! :create, @appliance_tmpl
  #   flag = @appliance_tmpl.save
  #   if flag
  #     flash[:notice] = 'Success.'
  #     redirect_to action: :index
  #   else
  #     flash[:alert] = "Cannot create appliance tmplate: #{@appliance_tmpl.errors.full_messages.join(', ')}."
  #     render action: :index
  #   end
  # end


  def edit
    authorize! :edit, @appliance
  end

  def index
    authorize! :index, Wco::Appliance
    @appliances = Wco::Appliance.all
  end

  def update
    authorize! :edit, @appliance
    flag = @appliance.update_attributes( params[:appliance].permit! )
    if flag
      flash[:notice] = "Success."
      redirect_to request.referrer ? request.referrer : { action: :edit, id: @appliance.id }
    else
      flash[:alert] = "Cannot update appliance: #{@appliance.errors.full_messages.join(', ')}."
      render action: :edit, id: @appliance.id
    end
  end


  ##
  ## private
  ##
  private

  def set_lists
    super
    @appliance = Wco::Appliance.find params[:id]
    @these_serverhosts_list = @appliance.leadset.serverhosts
  end

end

