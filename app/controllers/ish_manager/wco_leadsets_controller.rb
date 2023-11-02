
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
    @wco_leadset = Wco::Leadset.find params[:id]
    authorize! :update, @wco_leadset
    flag = @wco_leadset.update params[:wco_leadset].permit!
    if flag
      flash_notice "ok"
    else
      flash_alert "sorry"
    end
    redirect_to action: :index
  end

end

