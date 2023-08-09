
class IshManager::SubscriptionsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def index
    authorize! :index, Wco::Subscription

    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    @stripe_customers = Stripe::Customer.list().data
    @stripe_subscriptions = Stripe::Subscription.list().data

  end

end
