require 'prawn'
require 'prawn/table'

class ::IshManager::InvoicesController < IshManager::ApplicationController

  before_action :set_lists

  def create_monthly_pdf
    month_on = DateTime.strptime(params[:month_on], '%Y-%m-%d').strftime('%Y-%m-01')
    @leadset = Leadset.find params[:leadset_id]
    authorize! :create_monthly_invoice_pdf, @leadset

    @invoice = Ish::Invoice.where({ leadset_id: @leadset.id, month_on: month_on }).first
    if @invoice && !params[:replace]
      flash_alert "Already created this invoice."
      redirect_to controller: :leadsets, action: :show, id: @leadset.id
      return
    end

    if !@invoice
      @invoice = Ish::Invoice.create({
        leadset_id: @leadset.id,
        month_on:   month_on,
        number:     @leadset.next_invoice_number,
      })
      @leadset.update_attributes({ next_invoice_number: @leadset.next_invoice_number + 1 })
    end

    @pdf = @invoice.generate_monthly_invoice
    path = Rails.root.join 'tmp', @invoice.filename
    @pdf.render_file path
    data = File.read path

    asset = ::Gameui::Asset3d.new invoice: @invoice
    f = File.new( path )
    asset.object = f
    f.close
    @invoice.asset = asset
    if asset.save
      flash_notice "Saved the asset."
    end
    if @invoice.save
      flash_notice "Saved the invoice."
    end

    File.delete(path) if File.exist?(path)
    redirect_to controller: :leadsets, action: :show, id: @invoice.leadset_id

    # send_data( data, { :filename => @invoice.filename,
    #   :disposition => params[:disposition] ? params[:disposition] : :attachment,
    #   :type => 'application/pdf'
    # })
  end

  def create_stripe
    @invoice = Ish::Invoice.new params[:invoice].permit!
    authorize! :create, @invoice

    stripe_invoice = Stripe::Invoice.create({
      customer:          @invoice.leadset.customer_id,
      collection_method: 'send_invoice',
      days_until_due:    0,
      # collection_method: 'charge_automatically',
      pending_invoice_items_behavior: 'exclude',
    })
    params[:invoice][:items].each do |item|
      stripe_price = Wco::Product.find( item[:product_id] ).price_id
      invoice_item = Stripe::InvoiceItem.create({
        customer: @invoice.leadset.customer_id,
        price:    stripe_price,
        invoice:  stripe_invoice.id,
        quantity: item[:quantity],
      })
    end
    Stripe::Invoice.send_invoice(stripe_invoice[:id])
    @invoice.update_attributes({ invoice_id: stripe_invoice[:id] })

    if @invoice.save
      flash[:notice] = "Created the invoice."
      redirect_to action: :show, id: @invoice.id
    else
      flash[:alert] = "Cannot create invoice: #{@invoice.errors.messages}"
      render :new
    end
  end

  def index
    authorize! :index, Ish::Invoice
    @invoices = Ish::Invoice.all
    if params[:leadset_id]
      @invoices = @invoices.where( leadset_id: params[:leadset_id] )
    end
    @invoices = @invoices.includes( :payments )
  end

  def new_pdf
    authorize! :new, @invoice
    @leadset = Leadset.find params[:leadset_id]
    @products_list = Wco::Product.list
  end

  def new_stripe
    authorize! :new, @invoice
    @leadset       = Leadset.find params[:leadset_id]
    @products_list = Wco::Product.list
  end

  def email_send
    @invoice = Ish::Invoice.find params[:id]
    authorize! :send_email, @invoice
    out = ::IshManager::LeadsetMailer.monthly_invoice( @invoice.id.to_s )
    Rails.env.production? ? out.deliver_later : out.deliver_now
    flash_notice "Scheduled to send an email."
    redirect_to controller: :leadsets, action: :show, id: @invoice.leadset_id
  end

  def show
    @invoice = Ish::Invoice.find params[:id]
    authorize! :show, @invoice
    @stripe_invoice = Stripe::Invoice.retrieve @invoice.invoice_id
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
