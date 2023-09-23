
module IshManager
  class ApplicationMailer < ActionMailer::Base
    default from: 'WasyaCo Consulting <no-reply@wco.com.de>'
    helper(IshManager::ApplicationHelper)

    layout 'mailer'

    def shared_galleries profiles, gallery
      return if profiles.count == 0
      @gallery        = gallery
      @domain         = Rails.application.config.action_mailer.default_url_options[:host]
      @galleries_path = IshManager::Engine.routes.url_helpers.galleries_path
      @gallery_path   = IshManager::Engine.routes.url_helpers.gallery_path(@gallery.slug)
      mail( :to => '314658@gmail.com',
            :bcc => profiles.map { |p| p.email },
            :subject => 'You got new shared galleries on pi manager' )
    end

    def option_alert option
      @option = option
      mail({
        :to => option.profile.email,
        :subject => "IshManager Option Alert :: #{option.ticker}",
      })
    end

    def stock_alert watch_id
      @watch = Iro::OptionWatch.find watch_id
      mail({
        to: @watch.profile.email,
        subject: "Iro Watch Alert :: #{@watch.ticker} is #{@watch.direction} #{@watch.mark}."
      })
    end

    def test_email
      mail( to: DEFAULT_RECIPIENT, subject: "Test email at #{Time.now}" )
    end

  end
end
