
class ::IshManager::IroPositionsController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @position = Iro::Position.new({
      type: 'Iro::CoveredCall',
    })
    authorize! :update, @position

    if @position.update params[:iro_position].permit!
      flash[:notice] = 'Successfully updated position.'
      redirect_to controller: 'iro_purses', action: :show, id: params[:iro_position][:iro_purse_id]
    else
      flash[:alert] = "Cannot update position: #{@position.errors.full_messages.join(', ')}."
      render action: 'edit'
    end
  end

  def edit
    @position = Iro::Position.find params[:id]
    authorize! :edit, @position
  end

  def new
    @position = Iro::Position.new
    authorize! :new, @position
  end

  def update
    @position = Iro::Position.find params[:id]
    authorize! :update, @position

    if @position.update params[:iro_position].permit!
      flash[:notice] = 'Successfully updated position.'
      redirect_to controller: 'iro_purses', action: :show, id: @position[:iro_purse_id]
    else
      flash[:alert] = "Cannot update position: #{@position.errors.full_messages.join(', ')}."
      render action: 'edit'
    end
  end

end
