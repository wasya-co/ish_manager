
class IshManager::SubscriptionsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def index
    authorize! :index, Wco::Subscription

    @stripe_customers = Stripe::Customer.list().data
    @stripe_subscriptions = Stripe::Subscription.list().data

    emails = @stripe_customers.map &:email
    @leadsets = Leadset.find_by( email: emails )
    puts! @leadsets, '@leadsets'

  end

end
