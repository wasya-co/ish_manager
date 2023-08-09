
class IshManager::ProductsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def index
    authorize! :index, Wco::Product
    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    @products = Stripe::Product.list().data
  end

end
