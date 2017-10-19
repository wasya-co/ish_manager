
class IshManager::StockWatchesController < IshManager::ApplicationController

  def index
    authorize! :index, IshModels::StockWatch
    @profiles = IshModels::UserProfile.all
    @stock_watches = IshModels::StockWatch.all.includes( :profile )
    @stock_watch = IshModels::StockWatch.new
    render 'index', :layout => 'ish_manager/application_no_materialize'
  end

  def create
    @stock_watch = IshModels::StockWatch.new params[:ish_models_stock_watch].permit!
    authorize! :create, @stock_watch
    flag = @stock_watch.save
    if flag
      flash[:notice] = 'Created stock watch.'
    else
      flash[:alert] = "Cannot create stock watch: #{@stock_watch.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def update
    @stock_watch = IshModels::StockWatch.find params[:id]
    authorize! :update, @stock_watch
    flag = @stock_watch.update_attributes params[:ish_models_stock_watch].permit!
    if flag
      flash[:notice] = 'Updated stock watch.'
    else
      flash[:alert] = "Cannot update stock watch: #{@stock_watch.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end



