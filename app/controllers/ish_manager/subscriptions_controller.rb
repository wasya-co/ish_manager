
class IshManager::SubscriptionsController < IshManager::ApplicationController

  before_action :set_lists

  ## Alphabetized : )

  def create
    @subscription = Wco::Subscription.new params[:subscription].permit!
    authorize! :create, @subscription

    payment_methods = Stripe::Customer.list_payment_methods( params[:subscription][:customer_id] ).data
    # puts! payment_methods, 'payment_methods'

    params = {
      customer: params[:subscription][:customer_id],
      default_payment_method: payment_methods[0][:id],
      items: [
        { price: params[:subscription][:price_id] },
      ],
    }
    puts! params, 'params'
    @stripe_subscription = Stripe::Subscription.create( params )
    # puts! @stripe_subscription, '@stripe_subscription'


    flag = @subscription.save
    if flag
      flash[:notice] = 'Created the subscription.'
      redirect_to action: :show, id: @subscription.id
    else
      flash[:alert] = "Cannot create the subscription: #{@subscription.errors.full_messages.join(', ')}."
      render action: :new
    end
  end

  def index
    authorize! :index, Wco::Subscription

    @stripe_customers     = Stripe::Customer.list().data
    @stripe_subscriptions = Stripe::Subscription.list().data

    @customers     = {}
    customer_ids   = @stripe_customers.map &:id
    @leadsets      = Leadset.where( :customer_id.in => customer_ids )
    @leadsets.each do |i|
      @customers[i[:customer_id]] ||= {}
      @customers[i[:customer_id]][:leadsets] ||= []
      @customers[i[:customer_id]][:leadsets].push( i )
    end
    @profiles = Ish::UserProfile.where( :customer_id.in => customer_ids )
    @profiles.each do |i|
      @customers[i[:customer_id]] ||= {}
      @customers[i[:customer_id]][:profiles] ||= []
      @customers[i[:customer_id]][:profiles].push( i )
    end

    # puts! @customers, '@customers'
  end

  def new
    @subscription = Wco::Subscription.new
    authorize! :new, @subscription
  end

  def show
    @subscription = Wco::Subscription.find params[:id]
    authorize! :show, @subscription
  end

  ##
  ## private
  ##
  private

  def set_lists
    super
    @products_list     = Wco::Product.list
    leadsets = Leadset.where( "customer_id IS NOT NULL" ).map { |i| [ "leadset // #{i.company_url}", i.customer_id ] }
    profiles = ::Ish::UserProfile.where( :customer_id.ne => nil ).map { |i| [ "profile ++ #{i.email}", i.customer_id ] }
    @customer_ids_list = leadsets + profiles
    @price_ids_list    = Wco::Product.all.map { |i| [ i.name, i.price_id ] }
  end

end
