
class IshManager::SubscriptionsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def index
    authorize! :index, Wco::Subscription

    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    @customers = Stripe::Customer.list().data
    @users = User.all
    @organizations = Wco::Organization.all()
    @subscriptions = Stripe::Subscription.list().data
  end

end
