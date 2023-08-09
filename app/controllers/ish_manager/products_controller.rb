
class IshManager::ProductsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def create
    @product = Wco::Product.new params[:product].permit!
    authorize! :create, @product

    ##
    ## Stripe
    ##
    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    stripe_product = Stripe::Product.create({ name: params[:product][:name] })
    puts! stripe_product, 'stripe_product'

    price_hash = {
      product: stripe_product.id,
      unit_amount: params[:product][:price_cents],
      currency: 'usd',
    }
    if params[:product][:interval].present?
      price_hash[:recurring] = { interval: params[:product][:interval] }
    end
    stripe_price = Stripe::Price.create( price_hash )
    puts! stripe_price, 'stripe_price'


    flag = @product.save
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@product.errors.full_messages.join(', ')}."
    end
  end

  def destroy
    authorize! :destroy, Wco::Product
    # product = Wco::Product.find params[:id]

    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    flag = Stripe::Product.delete( params[:id] )
    # puts! flag, 'flag'
    flash[:notice] = flag
    # if product.destroy
    #   flash[:notice] = 'Success'
    # else
    #   flash[:alert] = "Cannot destroy product: #{product.errors.fill_messages.join(', ')}."
    # end
    redirect_to action: :index
  end

  def edit
    @product = Wco::Product.find params[:id]
    authorize! :edit, @product
  end

  def index
    authorize! :index, Wco::Product
    @stripe_products = {}

    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    @_stripe_products = Stripe::Product.list().data
    @_stripe_prices = Stripe::Price.list().data

    @_stripe_products.each do |sp|
      @stripe_products[sp[:id]] = sp
      @stripe_products[sp[:id]][:prices] ||= {}
    end
    @_stripe_prices.each do |price|
      @stripe_products[price[:product]][:prices][price[:id]] = price
    end

    @products = Wco::Product.all

  end

  def show
    authorize! :show, @product
    @product = Wco::Product.find params[:id]
  end

  def update
    authorize! :edit, @product
    @product = Wco::Product.find params[:id]

    if @product.update_attributes params[:product].permit!
      flash[:notice] = 'Success.'
      redirect_to action: :show, id: @product.id
    else
      flash[:alert] = "No luck: #{@product.errors.full_messages.join(', ')}."
      render action: :edit
    end

  end

end
