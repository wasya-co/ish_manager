
class ::IshManager::IroStrategiesController < IshManager::ApplicationController

  def create
    @strategy = Iro::CoveredCallStrategy.new params[:iro_strategy].permit!
    # @strategy.iro_purse_id = Iro::Purse.where( user_id: current_user.id ).first.id
    authorize! :create, @strategy
    flag = @strategy.save
    if flag
      flash[:notice] = 'Success.'
      redirect_to controller: 'ish_manager/iro_purses', action: :show, id: @strategy.iro_purse_id
    else
      flash[:alert] = "No luck: #{@strategy.errors.full_messages.join(', ')}."
      render action: 'new'
    end
  end

  def edit
    @strategy = Iro::CoveredCallStrategy.find params[:id]
    authorize! :edit, @strategy
  end

  def new
    @strategy = Iro::CoveredCallStrategy.new
    authorize! :new, @strategy
  end

  def update
    @strategy = Iro::CoveredCallStrategy.find params[:id]
    authorize! :update, @strategy
    flag = @strategy.update params[:iro_strategy].permit!
    if flag
      flash[:notice] = 'Success.'
      redirect_to controller: 'ish_manager/iro_purses', action: :show, id: @strategy.iro_purse_id
    else
      flash[:alert] = "No luck: #{@strategy.errors.full_messages.join(', ')}."
      render action: 'new'
    end
  end

end
