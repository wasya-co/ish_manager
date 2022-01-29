
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

namespace :ish_manager do

  desc "every user needs a user_profile"
  task :generate_user_profiles => :environment do
    User.all.map do |u|
      unless u.profile
        p = ::Ish::UserProfile.new :email => u.email, :user => u, :role_name => :guy
        u.profile = p
        u.save && p.save && print('.')
      end
    end
    puts 'OK'
  end

  desc 'watch the stocks, and trigger actions - not alphavantage, tda now. 2021-08-08'
  task watch_stocks: :environment do
    while true
      stocks = Warbler::StockWatch.where( notification_type: :EMAIL )
      stocks.each do |stock|
        begin
          Timeout::timeout( 10 ) do
            out = Warbler::Ameritrade::Api.get_quote({ symbol: stock.ticker })
            r = out[:lastPrice]
            if  stock.direction == :ABOVE && r >= stock.price ||
                stock.direction == :BELOW && r <= stock.price
              IshManager::ApplicationMailer.stock_alert( stock ).deliver
           end
          end
        rescue Exception => e
          puts! e, 'Error in ish_manager:watch_stocks :'
        end
      end
      sleep Warbler::StockWatch::SLEEP_TIME_SECONDS
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

end
