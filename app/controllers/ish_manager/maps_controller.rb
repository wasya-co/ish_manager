
class IshManager::MapsController < IshManager::ApplicationController

  def index
    authorize! :index, ::Gameui::Map
    @maps = ::Gameui::Map.all
  end

  def new
  end

end

