
class IshManager::AnalyticsController < IshManager::ApplicationController

  before_action :set_vars

  def index
    authorize! :analytics, IshManager::Ability
  end

  def test
    authorize! :analytics, IshManager::Ability

    if !@prev_intervals.include?( params[:prev_interval] )
      flash_error "prev_interval not allowed"
      redirect_to action: :index
      return
    end
    prev_interval = eval( params[:prev_interval] )
    puts! prev_interval, 'prev_interval'

    base_url = "https://analytics.wasya.co/index.php?force_api_session=1&module=API&format=JSON&"
    api_url_trash = "&idDimension=1&idSite=2&period=day&date=2023-07-01,2023-09-01"
    opts = {
      "token_auth" => ANALYTICS_TOKEN,

      # "method" => "Actions.getPageUrls",
      method: params[:method],

      "idDimension" => 1,

      # "idSite" => 2,
      idSite: params[:idSite],

      "period" => "day",
      # period: params[:period],

      "date" => "#{(Time.now - prev_interval ).to_date.to_s},#{Time.now.to_date.to_s}",
    }

    cids    = []
    reports = {}

    puts! "#{base_url}#{opts.to_query}", 'ze query'

    inns = HTTParty.get( "#{base_url}#{opts.to_query}" )
    inns = JSON.parse( inns.body )

    inns.each do |date, items|
      items.each do |item|

        path = item['label']
        if path[0] != '/'
          path = "/#{path}"
        end

        cid = path[/.*cid=([\d]*)/,1]&.to_i
        if cid
          cids.push cid
          reports[cid] ||= []
          reports[cid].push "#{date} :: #{path}"
        end
      end
    end

    cids        = cids.uniq.compact
    leads_h     = Lead.find_to_h cids
    @reports = {}

    reports.each do |k, v|
      lead_label = "[#{k}] <#{leads_h[k].name} #{leads_h[k].email}>"
      @reports[lead_label] = v
    end

  end

  ##
  ## private
  ##
  private

  def set_vars
    @methods_list = [
      "Actions.getPageUrls",
    ]


    @prev_intervals = [
      "1.month",
      "2.months",
      "3.months",
    ]

    @sites_list = [
      [ '2 - wasya.co', 2 ],
      [ '6 - wasyaco.com', 6 ],

      [ '3 - old pi', 3 ],
      [ '8 - pi_drup', 8 ],


      [ 'bjjc_drup', 9 ],
      [ 'bjjc_legacy', 12 ],

      [ 'demmitv', 7 ],

      [ 'ish', 5 ],


    ]
  end

end