
class ::IshManager::IroPursesController < IshManager::ApplicationController

  before_action :set_lists

  def my
    @purse = Iro::Purse.find_or_create_by({ user_id: current_user.id })
    authorize! :my, @purse
    @positions = @purse.positions
  end

end
