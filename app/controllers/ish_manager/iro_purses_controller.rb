
class ::IshManager::IroPursesController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @iro_purse = Iro::Purse.new({
      profile_id: current_profile.id,
    })
    authorize! :create, @iro_purse

    if @iro_purse.update params[:iro_purse].permit!
      flash[:notice] = 'Successfully created iro_purse.'
      redirect_to action: :show, id: @iro_purse.id
    else
      flash[:alert] = "Cannot create iro_purse: #{@iro_purse.errors.full_messages.join(', ')}."
      render action: 'edit'
    end
  end

  def edit
    @iro_purse = Iro::Purse.find params[:id]
    authorize! :edit, @iro_purse
  end

  def index
    @iro_purses = Iro::Purse.all
    authorize! :index, Iro::Purse
  end

  def new
    @iro_purse = Iro::Purse.new
    authorize! :new, @iro_purse
  end

  ## show_gameui too
  def show
    @purse = Iro::Purse.find params[:id]
    authorize! :my, @purse

    @strategies = Iro::CoveredCallStrategy.all
    @current_underlying_strike = @strategies[0].current_underlying_strike
    underlyings = Tda::Stock.get_quotes( @strategies.map(&:ticker).compact.uniq.join(",") )
    underlyings.each do |ticker, v|
      Iro::CoveredCallStrategy.where( ticker: ticker ).update( current_underlying_strike: v[:mark] )
    end

    if params[:statuses]
      @positions = @purse.positions.where( :status.in => params[:statuses].split(',') )
    else
      @positions = @purse.positions
    end
    @positions = @positions.order({ expires_on: :asc, strike: :asc })
    @positions.map &:refresh

    render params[:kind] || @purse.parsed_config[:kind] || 'show'
  end

  def roll_prep
    @strategies = Iro::CoveredCallStrategy.all
    @position = Iro::Position.find params[:id]
    puts! @position, '@position'
    @positions = [ @position ]
    @purse = @position.purse
    @strategy = @position.strategy
    authorize! :roll_prep, @position

    @next_positions = []
    next_date = @position.expires_on + 7.days # @TODO: change, watch hout for holidays

    [ -0.5, 0, 0.5, 1, 1.5 ].each do |price_step|
      next_position = Iro::CoveredCall.new({
        expires_on: next_date,
        strike: @position.strike + price_step,
        ticker: @strategy.ticker,
        opened_price: @position.current_price, # gain or loss upon roll
        # current_price: , # the price (size matters)
      })
      @next_positions.push( next_position )
    end
    @next_positions.map &:refresh
    @next_positions.map do |p|
      current_price = p.current_price
      p.opened_price = p.current_price
      current_price = current_price - @position.current_price # gain/loss diff
      p.current_price = p.opened_price - current_price
    end

    @next_positions.each do |p|
      puts! p, 'nexxt'
    end

    render params[:kind] || @purse.parsed_config[:kind] || 'show'
  end

  def update
    @iro_purse = Iro::Purse.find params[:id]
    authorize! :update, @iro_purse

    if @iro_purse.update params[:iro_purse].permit!
      flash[:notice] = 'Successfully updated iro_purse.'
      redirect_to action: :show, id: @iro_purse.id
    else
      flash[:alert] = "Cannot update iro_purse: #{@iro_purse.errors.full_messages.join(', ')}."
      render action: 'edit'
    end
  end

end

