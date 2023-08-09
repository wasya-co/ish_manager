
class IshManager::ProductsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def index
    authorize! :index, Wco::Product
    @products = {}

    Stripe.api_key = ::STRIPE_SK
    Stripe.api_version = '2020-08-27'
    @stripe_products = Stripe::Product.list().data
    @stripe_prices = Stripe::Price.list().data

    @stripe_products.each do |sp|
      @products[sp[:id]] = sp
      @products[sp[:id]][:prices] ||= {}
    end
    # puts! @products, '@products'

    @stripe_prices.each do |price|
      @products[price[:product]][:prices][price[:id]] = price
    end

  end

end
