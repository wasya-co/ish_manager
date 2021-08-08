
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

namespace :ish_manager do

  desc "every user needs a user_profile"
  task :generate_user_profiles => :environment do
    User.all.map do |u|
      unless u.profile
        p = ::IshModels::UserProfile.new :email => u.email, :user => u, :role_name => :guy
        u.profile = p
        u.save && p.save && print('.')
      end
    end
    puts 'OK'
  end

=begin
  desc 'watch the stocks, and trigger actions'
  task :watch_stocks => :environment do
    while true
      stocks = Ish::StockWatch.where( :notification_type => :EMAIL )
      puts! stocks.map(&:ticker), "Watching these stocks on #{Time.now}"
      stocks.each do |stock|
        begin
          Timeout::timeout( 10 ) do
            r = HTTParty.get "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{stock.ticker}&interval=1min&apikey=X1C5GGH5MZSXMF3O"
          end
        rescue Exception => e
          puts! e, 'e in :watch_stocks'
        end
        r = JSON.parse( r.body )['Time Series (1min)']
        r = r[r.keys.first]['4. close'].to_f
        if stock.direction == :ABOVE &&  r >= stock.price ||
           stock.direction == :BELOW && r <= stock.price
          IshManager::ApplicationMailer.stock_alert( stock ).deliver

          ## actions
          # stock.stock_actions.where( :is_active => true ).each do |action|
          #   # @TODO: actions
          # end

        end
      end
      sleep 60
    end
  end
=end

  desc 'watch the stocks, and trigger actions - not alphavantage, tda now. 2021-08-08'
  task :watch_stocks => :environment do
    while true
      stocks = Ish::StockWatch.where( :notification_type => :EMAIL )
      stocks.each do |stock|
        begin
          Timeout::timeout( 10 ) do
            out = Ish::Ameritrade::Api.get_quote({ symbol: stock.ticker })
            r = out[:lastPrice]
            if  stock.direction == :ABOVE &&  r >= stock.price ||
                stock.direction == :BELOW && r <= stock.price
              IshManager::ApplicationMailer.stock_alert( stock ).deliver
           end
          end
        rescue Exception => e
          puts! e, 'e in :watch_stocks'
        end
      end
      sleep 60
    end
  end

  desc 'watch condors'
  task watch_condors: :environment do
    watcher = ::Ish::IronCondorWatcher.new
    while true
      watcher.watch_once
      print '.'
      sleep 60 # seconds
    end
  end

=begin
  desc 'yahoo-watch the stocks'
  task :stockwatcher => :environment do
    watcher = YahooStockwatcher.new
    while true
      watcher.watch_once
      print '.'
      sleep 60 # seconds
    end
  end
=end

end
