
class ::IshManager::IroWatchersController < IshManager::ApplicationController

  # before_action :set_lists

  # def create
  #   @alert = Iro::Alert.new params[:iro_alert].permit!
  #   authorize! :create, @alert
  #   flag = @alert.save
  #   if flag
  #     flash[:notice] = 'Created iro alert.'
  #   else
  #     flash[:alert] = "Cannot create iro alert: #{@alert.errors.full_messages.join(', ')}."
  #   end
  #   redirect_to action: 'index'
  # end

  # def destroy
  #   @w = Iro::Alert.find params[:id]
  #   authorize! :destroy, @w
  #   flag = @w.destroy
  #   if flag
  #     flash[:notice] = 'Success.'
  #   else
  #     flash[:alert] = @w.errors.full_messages.join(", ")
  #   end
  #   redirect_to action: 'index'
  # end

  def index
    authorize! :index, Iro::Watcher
    # @alerts = Iro::Alert.order_by( ticker: :asc, direction: :asc, price: :desc)
    # @option_get_chains = Iro::OptionGet.all_get_chains
  end

  # def update
  #   @alert = Iro::Alert.find params[:id]
  #   authorize! :update, @alert
  #   flag = @alert.update_attributes params[:iro_alert].permit!
  #   if flag
  #     flash[:notice] = 'Updated iro alert.'
  #   else
  #     flash[:alert] = "Cannot update iro alert: #{@alert.errors.full_messages.join(', ')}."
  #   end
  #   redirect_to action: 'index'
  # end

end
