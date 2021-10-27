
class IshManager::PaymentsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::Payment
    @payments = Ish::Payment.all.includes( :invoice )
  end

end
