
class IshManager::WcoLeadsetsController < IshManager::ApplicationController

  def create
  end

  def edit
    @wco_leadset = Wco::Leadset.find params[:id]
    authorize! :edit, @wco_leadset
  end

  def index
    authorize! :index, Wco::Leadset
    @wco_leadsets = Wco::Leadset.all
  end

  def show
    @wco_leadset = Wco::Leadset.find params[:id]
    authorize! :show, @wco_leadset
  end

  def update
  end

end

