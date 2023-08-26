
class ::IshManager::IroOptionGetsController < IshManager::ApplicationController

  # before_action :set_lists

  def create
    @item = Iro::OptionGet.new params[:iro_option_get].permit!
    @item.kind = Iro::OptionGet::KIND_GET_CHAINS
    authorize! :create, @item
    flag = @item.save
    if flag
      flash[:notice] = 'Created option_get.'
    else
      flash[:alert] = "Cannot create option_get: #{@item.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index', controller: 'ish_manager/iro_watches'
  end

  def max_pain
    authorize! :max_pain, Iro::Iro
    @ticker = params[:ticker]

    @expirationDate = ( params[:date].to_date + 15.hours ).to_time.to_i * 1000 # '1689364800000'
    # expirationDate = '1689969600000'
    # expirationDate = '1690574400000'
    @all_items = {}

    calls_sql = " select distinct putCall, symbol, strikePrice, openInterest, max(created_at)
      from iro_option_price_items
      where expirationDate = #{@expirationDate} and putCall = 'CALL' and ticker = '#{@ticker}'
      group by putCall, symbol, strikePrice, openInterest
      order by strikePrice, max(created_at) desc; "
    @calls_items = []
    @calls_array = ActiveRecord::Base.connection.execute(calls_sql)
    calls_subtotal = 0
    @calls_array.each do |_item|
      # puts! _item, 'item'
      item = {
        putCall:     _item[0],
        symbol:      _item[1],
        strikePrice: _item[2],
        oi:          _item[3],
        created_at:  _item[4],
      }
      # puts! item, 'item'
      item[:subtotal] = item[:strikePrice] * 100 * item[:oi]
      calls_subtotal = calls_subtotal + item[:subtotal]
      item[:total] = calls_subtotal
      puts! item, 'item'
      @calls_items.push( item )

      @all_items[item[:strikePrice]] ||= {
        subtotal: 0,
        strikePrice: item[:strikePrice],
      }
      @all_items[item[:strikePrice]][:calls_subtotal] = calls_subtotal
      @all_items[item[:strikePrice]][:calls_oi] = item[:oi]
      @all_items[item[:strikePrice]][:subtotal] = @all_items[item[:strikePrice]][:subtotal] + calls_subtotal
    end

    puts_sql = "select putCall, symbol, strikePrice, openInterest, created_at
    from iro_option_price_items
    where expirationDate = #{@expirationDate} and putCall = 'PUT' and ticker = '#{@ticker}'
    group by putCall, symbol, strikePrice, openInterest, created_at
    order by putCall, strikePrice, created_at desc;"
    @puts_items = []
    @puts_array = ActiveRecord::Base.connection.execute(puts_sql)
    puts_subtotal = 0
    @puts_array.each do |_item|
      item = {
        putCall:     _item[0],
        symbol:      _item[1],
        strikePrice: _item[2],
        oi:          _item[3],
        created_at:  _item[4],
      }
      item[:subtotal] = item[:strikePrice] * 100 * item[:oi]
      puts_subtotal = puts_subtotal + item[:subtotal]
      item[:total] = puts_subtotal
      puts! item, 'item'
      @puts_items.push( item )
      @all_items[item[:strikePrice]] ||= {
        subtotal: 0,
        strikePrice: item[:strikePrice],
      }
      @all_items[item[:strikePrice]][:puts_subtotal] = puts_subtotal
      @all_items[item[:strikePrice]][:puts_oi] = item[:oi]
      @all_items[item[:strikePrice]][:subtotal] = @all_items[item[:strikePrice]][:subtotal] + puts_subtotal
    end


    render 'ish_manager/iro_watches/max_pain'
  end

  # def destroy
  #   @w = Iro::OptionWatch.find params[:id]
  #   authorize! :destroy, @w
  #   flag = @w.destroy
  #   if flag
  #     flash[:notice] = 'Success.'
  #   else
  #     flash[:alert] = @w.errors.full_messages.join(", ")
  #   end
  #   redirect_to action: 'index'
  # end

  # def index
  #   authorize! :index, Iro::OptionWatch
  #   @watches = Iro::OptionWatch.order_by( ticker: :asc, direction: :asc, price: :desc)
  #   @option_get_chains = Iro::OptionGet.all_get_chains
  # end

  # def update
  #   @option_watch = Iro::OptionWatch.find params[:id]
  #   authorize! :update, @option_watch
  #   flag = @option_watch.update_attributes params[:iro_watch].permit!
  #   if flag
  #     flash[:notice] = 'Updated option watch.'
  #   else
  #     flash[:alert] = "Cannot update option watch: #{@option_watch.errors.full_messages.join(', ')}."
  #   end
  #   redirect_to action: 'index'
  # end

end
