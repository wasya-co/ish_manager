
class IshManager::StockOptionsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::StockOption
    @profiles = IshModels::UserProfile.all
    @stock_options = Ish::StockOption.all.includes( :profile )
    @stock_option = Ish::StockOption.new
    render 'index', :layout => 'ish_manager/application_no_materialize'
  end

  def create
    @stock_option = Ish::StockOption.new params[:ish_stock_option].permit!
    @stock_option.profile = current_user.profile
    authorize! :create, @stock_option
    flag = @stock_option.save

    if flag
      flash[:notice] = 'Created stock option.'
    else
      flash[:alert] = "Cannot create stock option: #{@stock_option.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def update
    @stock_option = Ish::StockOption.find params[:id]
    authorize! :update, @stock_option
    flag = @stock_option.update_attributes params[:ish_stock_option].permit!
    if flag
      flash[:notice] = 'Updated stock option.'
    else
      flash[:alert] = "Cannot update stock option: #{@stock_option.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end



