
class ::IshManager::IroPursesController < IshManager::ApplicationController

  before_action :set_lists

  def my
    @purse = Iro::Purse.find_or_create_by({ user_id: current_user.id })
    authorize! :my, @purse
    @positions = @purse.positions.order({ expires_on: :asc, strike: :asc })
    @strategies = Iro::CoveredCallStrategy.where({
      iro_purse_id: Iro::Purse.find_by( user_id: current_user.id ).id,
    })
  end

end

=begin
    @strategy = {
      buffer_above_water: 0.49, # be this much $ above current price, in next position
      next_max_delta: 0.25, # of next position
      next_min_price: 16,
      threshold_delta: 0.14, # should roll at this delta
      threshold_netp: 0.69, # should roll at the net %
      target_profilt: 0.19, # unused
      current_underlying_strike: 16.6,
    }
=end