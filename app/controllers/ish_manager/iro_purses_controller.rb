
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

  def show
    @purse = Iro::Purse.find params[:id]
    authorize! :my, @purse

    @strategies = Iro::CoveredCallStrategy.all
    underlyings = Tda::Stock.get_quotes( @strategies.map(&:ticker).compact.uniq.join(",") )
    # json_puts! underlyings, 'out'
    underlyings.each do |ticker, v|
      # puts! v[:mark], 'ze mark'
      Iro::CoveredCallStrategy.where( ticker: ticker ).update( current_underlying_strike: v[:mark] )
    end

    @positions = @purse.positions.order({ expires_on: :asc, strike: :asc })
    @positions.map &:refresh

    render @purse.parsed_config[:kind] || params[:kind] || 'show'
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

