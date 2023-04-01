
class ::IshManager::IroPositionsController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @position = Iro::Position.new({
      iro_purse: @purse = Iro::Purse.find_or_create_by({ user_id: current_user.id }),
      type: 'Iro::CoveredCall',
    })
    authorize! :update, @position

    if @position.update params[:position].permit!
      flash[:notice] = 'Successfully updated position.'
      redirect_to controller: 'iro_purses', action: :show
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

    if @position.update params[:position].permit!
      flash[:notice] = 'Successfully updated position.'
      redirect_to controller: 'iro_purses', action: :show
    else
      flash[:alert] = "Cannot update position: #{@position.errors.full_messages.join(', ')}."
      render action: 'edit'
    end
  end

end
