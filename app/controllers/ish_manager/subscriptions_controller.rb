
class IshManager::SubscriptionsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def create
    authorize! :create, Wco::Subscription
    @subscription = Wco::Subscription.new params[:subscription].permit!
    @stripe_subscription = Stripe::Subscription.create({
      customer: params[:subscription][:customer_id],
      items: [
        { price: params[:subscription][:price_id] },
      ],
    })
    puts! @stripe_subscription, '@stripe_subscription'

    # flag = @subscription.save
    # if flag
    #   flash[:notice] = 'Created the subscription.'
    #   redirect_to action: :show, id: @subscription.id
    # else
    #   flash[:alert] = "Cannot create the subscription: #{@subscription.errors.full_messages.join(', ')}."
    #   render action: :new
    # end
  end

  def index
    authorize! :index, Wco::Subscription

    @stripe_customers = Stripe::Customer.list().data
    @stripe_subscriptions = Stripe::Subscription.list().data

    emails = @stripe_customers.map &:email
    @leadsets = Leadset.find_by( email: emails )
  end

  def show
    authorize! :show, Wco::Subscription
    @subscription = Wco::Subscription.find params[:id]
  end

  def new
    authorize! :new, Wco::Subscription
    @subscription = Wco::Subscription.new
  end

  ##
  ## private
  ##
  private

  def set_lists
    super
    @products_list = Wco::Product.list
    @customer_ids_list = Leadset.where( "customer_id IS NOT NULL" ).map { |i| [ i.company_url, i.customer_id ] }
    @price_ids_list = Wco::Product.all.map { |i| [ i.name, i.price_id ] }
  end

end
