class IshManager::LeadsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::Lead
    @leads = Ish::Lead.all
  end

  def new
    @new_lead = Ish::Lead.new
    authorize! :new, @new_lead
  end

  def create
    @lead = Ish::Lead.new params[:lead].permit!
    authorize! :create, @lead
    if @lead.save
      flash[:notice] = "created lead"
    else
      flash[:alert] = "Cannot create lead: #{@lead.errors.messages}"
    end
    redirect_to :action => 'index'
  end

=begin
  def update
    @invoice = Ish::Invoice.find params[:id]
    authorize! :update, @invoice
    if @invoice.update_attributes params[:invoice].permit!
      flash[:notice] = 'Success'
      redirect_to :action => 'index'
    else
      flash[:alert] = "Cannot update invoice: #{@invoice.errors.messages}"
    end
    redirect_to :action => 'index'
  end
=end

end
