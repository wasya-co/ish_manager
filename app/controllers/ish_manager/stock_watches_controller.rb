
class IshManager::StockWatchesController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::StockWatch
    @profiles = IshModels::UserProfile.all
    @stock_watches = Ish::StockWatch.order_by( ticker: :asc, direction: :asc, price: :desc
      ).includes( :profile )
    @stock_watch = Ish::StockWatch.new
    render 'index', :layout => 'ish_manager/application_no_materialize'
  end

  def create
    @stock_watch = Ish::StockWatch.new params[:ish_stock_watch].permit!
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
    @stock_watch = Ish::StockWatch.find params[:id]
    authorize! :update, @stock_watch
    flag = @stock_watch.update_attributes params[:ish_stock_watch].permit!
    if flag
      flash[:notice] = 'Updated stock watch.'
    else
      flash[:alert] = "Cannot update stock watch: #{@stock_watch.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def destroy
    @w = Ish::StockWatch.find params[:id]
    authorize! :destroy, @w
    flag = @w.destroy
    if flag
      flash[:notice] = 'Success.'
    else
      flash[:alert] = @w.errors.messages
    end
    redirect_to action: 'index'
  end

end



