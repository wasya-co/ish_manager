module IshManager
  module ApplicationHelper


    #
    # api paths
    #
    def api_map_path map
      "/api/maps/view/#{map.slug}"
    end

    def api_marker_path marker
      "/api/markers/view/#{marker.id}"
    end


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

    def my_truthy? which
      ["1", "t", "T", "true"].include?( which )
    end

    # def email_contexts_for_lead_path lead
    #   "/manager/email_contexts/for_lead/#{lead.id.to_s}"
    # end

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
      # date.to_s[0, 10]
      date&.strftime('%Y-%m-%d')
    end
    def pp_date a; pretty_date a; end
    def pp_datetime date
      date&.strftime('%Y-%m-%d %l:%M%P %z')
    end
    def pp_time date
      date&.strftime('%l:%M%P %z')
    end

    def pp_amount a
      return '-' if !a
      "$ #{'%.2f' % a}"
    end
    def pp_money a; pp_amount a; end
    def pp_currency a; pp_amount a; end
    def pp_percent a
      "#{(a*100).round(2)}%"
    end

    def pp_bool a
      a ? 'Y' : '-'
    end

  end
end
