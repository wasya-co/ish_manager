
class IshManager::AnalyticsController < IshManager::ApplicationController

  def test
    authorize! :analytics, IshManager::Ability

    base_url = "https://analytics.wasya.co/index.php?force_api_session=1&module=API&format=JSON&"
    opts = {
      "method" => "Actions.getPageUrls",
      "token_auth" => ANALYTICS_TOKEN,
      "idDimension" => 1,
      "idSite" => 2,
      "period" => "day",
      "date" => "#{(Time.now - 3.months ).to_date.to_s},#{Time.now.to_date.to_s}",
    }
    api_url = "&idDimension=1&idSite=2&period=day&date=2023-07-01,2023-09-01"
    cids    = []
    reports = {}

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
      email = leads_h[k].email
      @reports[email] = v
    end

  end

end