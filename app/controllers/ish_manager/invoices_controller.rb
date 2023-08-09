
class ::IshManager::InvoicesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :index, Ish::Invoice
    @invoices = Ish::Invoice.all.includes( :payments )
  end

  def new
    authorize! :new, @invoice
    @leadset = Leadset.find params[:leadset_id]
    @products_list = Wco::Product.list
  end

  def create
    @invoice = Ish::Invoice.new params[:invoice].permit!
    @leadset = Leadset.find params[:leadset_id]
    authorize! :create, @invoice

    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    stripe_invoice = Stripe::Invoice.create({
      customer:          @leadset.customer_id,
      collection_method: 'send_invoice', # @TODO: change?
      days_until_due:    30, # @TODO: change?
      pending_invoice_items_behavior: 'exclude',
    })
    params[:invoice][:items].each do |item|
      invoice_item = Stripe::InvoiceItem.create({
        customer: @leadset.customer_id,
        price:    item,
        invoice:  stripe_invoice.id,
      })
    end
    Stripe::Invoice.send_invoice(stripe_invoice[:id])

    if @invoice.save
      flash[:notice] = "Created the invoice."
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
