
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


#   select t1.putCall, t1.symbol, t1.strikePrice, t1.openInterest, t1.created_at
#   from iro_option_price_items t1
#   join (
#     select symbol, max(created_at) as c1
# from iro_option_price_items
# where expirationDate = 1694808000000 and ticker = 'GME'
# group by symbol ) as t2
#   on t1.symbol = t2.symbol and t1.created_at = t2.c1
#   order by t1.strikePrice, t1.created_at desc;


  ##
  ## Tda::Option.get_chain({ ticker: 'GME' })
  ##
  ## SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
  ## SET sql_mode=(SELECT CONCAT(@@sql_mode,',ONLY_FULL_GROUP_BY'));
  ##
  def max_pain
    authorize! :max_pain, Iro::Iro
    @ticker         = params[:ticker]
    @expirationDate = ( params[:date].to_date + 15.hours ).to_time.to_i * 1000
    # puts! @expirationDate, '@expirationDate'
    @all_items      = {}

    sql = " select distinct putCall, symbol, strikePrice, openInterest, max(created_at)
      from iro_option_price_items
      where expirationDate = #{@expirationDate} and ticker = '#{@ticker}'
      group by putCall, symbol, strikePrice
      order by strikePrice, max(created_at) desc; "

    results_array   = ActiveRecord::Base.connection.execute(sql)
    results_array.each do |_item|
      # puts! _item, '_item'
      item = {
        putCall:     _item[0],
        symbol:      _item[1],
        strikePrice: _item[2],
        oi:          _item[3],
        created_at:  _item[4],
      }
      @all_items[item[:strikePrice]] ||= {
        strike_price: item[:strikePrice],
        call_max_pain: 0,
        put_max_pain: 0,
      }
      if 'CALL' == item[:putCall]
        @all_items[item[:strikePrice]][:call_oi] = item[:oi]
      else
        @all_items[item[:strikePrice]][:put_oi] = item[:oi]
      end
    end

    @all_items.each_with_index do |_item, idx|
      strike_price = _item[0]
      item = _item[1]
      # break if idx > 3
      # puts! item, 'item'

      @all_items.each do |next_strike_price, next_item|
        if next_strike_price < strike_price
          if next_item[:call_oi] > 0
            @all_items[strike_price][:call_max_pain] += 100 * next_item[:call_oi] * (strike_price - next_strike_price)
          end
        end

        if next_strike_price > strike_price
          if next_item[:put_oi] > 0
            @all_items[strike_price][:put_max_pain] += 100 * next_item[:put_oi] * (next_strike_price - strike_price)
          end
        end
      end


    end

    # puts_sql = "select putCall, symbol, strikePrice, openInterest, created_at
    # from iro_option_price_items
    # where expirationDate = #{@expirationDate} and putCall = 'PUT' and ticker = '#{@ticker}'
    # group by putCall, symbol, strikePrice, openInterest, created_at
    # order by putCall, strikePrice, created_at desc;"
    # @puts_items = []
    # @puts_array = ActiveRecord::Base.connection.execute(puts_sql)
    # puts_subtotal = 0
    # @puts_array.each do |_item|
    #   item = {
    #     putCall:     _item[0],
    #     symbol:      _item[1],
    #     strikePrice: _item[2],
    #     oi:          _item[3],
    #     created_at:  _item[4],
    #   }
    #   item[:subtotal] = item[:strikePrice] * 100 * item[:oi]
    #   puts_subtotal = puts_subtotal + item[:subtotal]
    #   item[:total] = puts_subtotal
    #   puts! item, 'item'
    #   @puts_items.push( item )
    #   @all_items[item[:strikePrice]] ||= {
    #     subtotal: 0,
    #     strikePrice: item[:strikePrice],
    #   }
    #   @all_items[item[:strikePrice]][:puts_subtotal] = puts_subtotal
    #   @all_items[item[:strikePrice]][:puts_oi] = item[:oi]
    #   @all_items[item[:strikePrice]][:subtotal] = @all_items[item[:strikePrice]][:subtotal] + puts_subtotal
    # end


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
