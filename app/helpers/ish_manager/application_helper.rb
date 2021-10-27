module IshManager
  module ApplicationHelper

    def pretty_date input
      return input.strftime("%Y-%m-%d")
    end

    def pp_errors errors
      return errors
    end

    def user_path user
      if user.class == 'String'
        "/users/#{user}"
      elsif user.class == User
        "/users/#{user.id}"
      elsif user.class == NilClass
        "/users"
      end
    end

    def pretty_date date
      date.to_s[0, 10]
    end
    def pp_date a; pretty_date a; end

    def pp_amount a
      "$ #{'%.2f' % a}"
    end

    def resource_path resource
      case resource.class.name
      when 'City'
        city_path( resource.id )
      when 'Event'
        event_path( resource.id )
      when 'Venue'
        venue_path( resource.id )
      end
    end

    #
    # api paths
    #
    def api_city_path city
      "/api/cities/view/#{city.cityname}.json"
    end

    def api_map_path map
      "/api/maps/view/#{map.slug}"
    end

    def api_marker_path marker
      "/api/markers/view/#{marker.slug}"
    end

  end
end
