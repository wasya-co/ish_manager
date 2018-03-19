
class IshManager::CoTailorsController < IshManager::ApplicationController

  def home
    authorize! :home, ::CoTailors
    @products = ::CoTailors::Product.all
  end

end

