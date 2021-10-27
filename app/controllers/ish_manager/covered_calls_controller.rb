
class IshManager::CoveredCallsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::CoveredCall
  end

end

