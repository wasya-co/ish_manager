
class IshManager::InvoicesController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::Invoice
    @invoices = Ish::Invoice.all
    @new_invoice = Ish::Invoice.new
  end

  def new
    @invoice = Ish::Invoice.new
    authorize! :new, @invoice
  end

  def create
    @invoice = Ish::Invoice.new params[:invoice].permit!
    authorize :create, @invoice
    if @invoice.save
      flash[:notice] = "created invoice"
    else
      flash[:alert] = "Cannot create invoice: #{@invoice.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def update
    @invoice = Ish::Invoice.find params[:id]
    if @invoice.update_attributes params[:invoice].permit!
      flash[:notice] = 'Success'
      redirect_to :action => 'index'
    else
      flash[:alert] = "Cannot update invoice: #{@invoice.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end
