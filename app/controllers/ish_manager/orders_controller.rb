
class IshManager::OrdersController < IshManager::ApplicationController

  before_action :set_lists

  def index
    @orders = ::CoTailors::Order.all
    authorize! :index, CoTailors::Order
  end

end

