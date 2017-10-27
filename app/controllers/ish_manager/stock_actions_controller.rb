
class IshManager::StockActionsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::StockAction
    @profiles      = IshModels::UserProfile.all
    @stock_watches_list = Ish::StockWatch.all.map { |w| [w.to_s, w.id] }
    @stock_options_list = Ish::StockOption.all.map { |o| [ o.to_s, o.id] }
    @stock_actions = Ish::StockAction.all.includes( :profile )
    @stock_action  = Ish::StockAction.new
    render 'index', :layout => 'ish_manager/application_no_materialize'
  end

  def create
    @stock_action = Ish::StockAction.new :stock_watch => params[:ish_stock_action][:stock_watch]
    @stock_action.profile = current_user.profile
    authorize! :create, @stock_action

    flag = true
    if params[:ish_stock_action][:stock_options]
      stock_options = Ish::StockOption.where( :id.in => params[:ish_stock_action][:stock_options] )
      flag = stock_options.update_all( :stock_action_id => @stock_action.id )
    end
    if flag
      flag = @stock_action.save
    end
    if flag
      flash[:notice] = 'Created stock action.'
    else
      flash[:alert] = "Cannot create stock action: #{@stock_action.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def update
    @stock_action = Ish::StockAction.find params[:id]
    authorize! :update, @stock_action

    stock_options = Ish::StockOption.where( :stock_action_id => @stock_action.id ).update_all( :stock_action_id => nil )
    flag = true
    if params[:ish_stock_action][:stock_options]
      stock_options = Ish::StockOption.where( :id.in => params[:ish_stock_action][:stock_options] )
      flag = stock_options.update_all( :stock_action_id => @stock_action.id )
    end
    if flag
      flag = @stock_action.update_attributes :stock_watch => params[:ish_stock_action][:stock_watch]
    end
    if flag
      flash[:notice] = 'Updated stock action.'
    else
      flash[:alert] = "Cannot update stock action: #{@stock_action.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end



