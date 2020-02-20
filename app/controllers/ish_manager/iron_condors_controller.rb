
class IshManager::IronCondorsController < IshManager::ApplicationController

  def index
    authorize! :index, ::Ish::IronCondor
    @condors = ::Ish::IronCondor.all
  end

  def create
  end

  def destroy
  end

end
