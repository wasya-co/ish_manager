
class ::IshManager::InvoicesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :index, Ish::Invoice
    @invoices = Ish::Invoice.all.includes( :payments )
  end

  def new
    authorize! :new, @invoice
  end

  def create
    @invoice = Ish::Invoice.new params[:invoice].permit!
    authorize! :create, @invoice
    if @invoice.save
      flash[:notice] = "created invoice"
    else
      flash[:alert] = "Cannot create invoice: #{@invoice.errors.messages}"
    end
    redirect_to :action => 'index'
  end

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

  #
  # private
  #
  private

  def set_lists
    @invoice_number = Ish::Invoice.order_by( :number => :desc ).first
    @invoice_number = @invoice_number ? @invoice_number.number + 1 : 1
    @new_invoice = Ish::Invoice.new :number => @invoice_number
  end

end
