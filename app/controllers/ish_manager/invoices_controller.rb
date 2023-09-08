require 'prawn'
require 'prawn/table'

class ::IshManager::InvoicesController < IshManager::ApplicationController

  before_action :set_lists

  def create_monthly_pdf
    @leadset = Leadset.find params[:leadset_id]
    authorize! :create_monthly_invoice_pdf, @leadset

    @invoice = Ish::Invoice.where({ leadset_id: @leadset.id, month_on: params[:month_on] }).first
    if @invoice
      flash_alert "Already created this invoice."
      redirect_to controller: :leadsets, action: :show, id: @leadset.id
      return
    end

    @invoice = Ish::Invoice.create({ leadset_id: @leadset.id, month_on: params[:month_on] })

    @pdf = @invoice.generate_monthly_invoice params[:month_on]
    filename = "invoice-#{@invoice.number}.pdf"
    path = Rails.root.join 'tmp', filename
    @pdf.render_file path
    data = File.read path
    File.delete(path) if File.exist?(path)

    send_data( data, { :filename => filename,
      :disposition => params[:disposition] ? params[:disposition] : :attachment,
      :type => 'application/pdf'
    })
  end


  ## @TODO: obsolete, remove
  ##
  def create_pdf
    @invoice = Ish::Invoice.new
    authorize! :new, @invoice

    tree_img_url = "#{Rails.root.join('public')}/tree-1.jpg"
    wasya_co_logo_url = "#{Rails.root.join('public')}/259x66-WasyaCo-logo.png"

    pdf = Prawn::Document.new

    pdf.canvas do
      pdf.image tree_img_url, at: [ 0, 792 ], width: 612

      pdf.fill_color 'ffffff'
      pdf.transparent( 0.75 ) do
        pdf.fill_rectangle [0, 792], 612, 792
      end
      pdf.fill_color '000000'

      pdf.image wasya_co_logo_url, at: [252, 720], width: 108 ## 1.5"

      pdf.bounding_box( [0.75*72, 9.25*72], width: 3.25*72, height: 0.75*72 ) do
        pdf.text "From:"
        pdf.text "Wasya Co"
        pdf.text "(415) 948-0368"
      end

      pdf.bounding_box( [4.5*72, 9.25*72], width: 3.25*72, height: 0.75*72 ) do
        pdf.text "Stats:"
        pdf.text "Date: #{ '2023-09-07' }"
        pdf.text "Invoice # #{ '111' }"
      end

      pdf.bounding_box( [0.75*72, 8.25*72], width: 3.25*72, height: 0.75*72 ) do
        pdf.text "To:"
        pdf.text "Creen Enterprise"
      end

      pdf.bounding_box( [4.5*72, 8.25*72], width: 3.25*72, height: 0.75*72 ) do
        pdf.text "Notes:"
        pdf.text "Support & various, for the month of August '23."
      end

      pdf.move_down 20

      pdf.table([
        [ 'Description', 'Type', 'Hours', 'Subtotal' ],
        [ 'Part 2/2', 'indep. proj.', '-', '$3,501' ],
      ], {
        position: :center,
        width: 7.5*72,
        cell_style: {
          inline_format: true,
          borders: [ :bottom ]
        },
      } )

      pdf.table([
        [ 'Total' ],
        [ '$3,501' ],
      ], {
        position: 7*72,
        width: 1*72,
        cell_style: {
          inline_format: true,
          borders: [ :bottom ]
        },
      } )

      pdf.text_box "Thank you!", at: [ 3.25*72, 1.25*72 ], width: 2*72, height: 1*72, align: :center
    end

    filename = "a-summary.pdf"
    path = Rails.root.join 'tmp', filename
    pdf.render_file path
    data = File.read path
    File.delete(path) if File.exist?(path)

    send_data( data, { :filename => filename,
      :disposition => params[:disposition] ? params[:disposition] : :attachment,
      :type => 'application/pdf'
    })
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
