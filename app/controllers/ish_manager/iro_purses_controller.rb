
class ::IshManager::IroPursesController < IshManager::ApplicationController

  before_action :set_lists

  def show
    @purse = Iro::Purse.find_or_create_by({ user_id: current_user.id })
    authorize! :my, @purse

    @strategies = Iro::CoveredCallStrategy.where({
      iro_purse_id: Iro::Purse.find_by( user_id: current_user.id ).id,
    })

    underlyings = Tda::Stock.get_quotes( @strategies.map(&:ticker).compact.uniq.join(",") )
    # json_puts! underlyings, 'out'
    underlyings.each do |ticker, v|
      Iro::CoveredCallStrategy.where( ticker: ticker ).update( current_underlying_strike: v[:mark] )
    end

    @positions = @purse.positions.order({ expires_on: :asc, strike: :asc })
    @positions.map &:refresh
  end

end

