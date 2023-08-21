
class ::IshManager::IroWatchesController < IshManager::ApplicationController

  # before_action :set_lists

  def create
    @option_watch = Iro::OptionWatch.new params[:iro_watch].permit!
    authorize! :create, @option_watch
    flag = @option_watch.save
    if flag
      flash[:notice] = 'Created option watch.'
    else
      flash[:alert] = "Cannot create option watch: #{@option_watch.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index'
  end

  def destroy
    @w = Iro::OptionWatch.find params[:id]
    authorize! :destroy, @w
    flag = @w.destroy
    if flag
      flash[:notice] = 'Success.'
    else
      flash[:alert] = @w.errors.full_messages.join(", ")
    end
    redirect_to action: 'index'
  end

  def index
    authorize! :index, Iro::OptionWatch
    @watches = Iro::OptionWatch.order_by( ticker: :asc, direction: :asc, price: :desc)
    @option_get_chains = Iro::OptionGet.all_get_chains
  end

  def update
    @option_watch = Iro::OptionWatch.find params[:id]
    authorize! :update, @option_watch
    flag = @option_watch.update_attributes params[:iro_watch].permit!
    if flag
      flash[:notice] = 'Updated option watch.'
    else
      flash[:alert] = "Cannot update option watch: #{@option_watch.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index'
  end

end
