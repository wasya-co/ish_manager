module IshManager
  module ApplicationHelper

    def current_layout
      layout = controller.class.send(:_layout)
      if layout.nil?
        '<default>'
      elsif layout.instance_of? String or layout.instance_of? Symbol
        layout
      else
        layout.inspect
        # File.basename(layout.identifier).split('.').first
      end
    end

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

    #
    # api paths
    #
    def api_map_path map
      "/api/maps/view/#{map.slug}"
    end

    def api_marker_path marker
      "/api/markers/view/#{marker.id}"
    end

  end
end
