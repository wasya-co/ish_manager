
module IshManager
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'

    def stock_alert stock
      @stock = stock
      mail( :to => stock.profile.email, :subject => "IshManager Stock Alert :: #{stock.ticker}" ).deliver
    end

    def condor_followup_alert condor, args
      @condor = condor
      @args = args
      mail( to: 'piousbox@gmail.com', subject: "Condor Followup Alert :: #{condor.ticker} #{args.to_s}" ).deliver
    end

    def shared_galleries profiles, gallery
      return if profiles.count == 0
      @gallery        = gallery
      @domain         = Rails.application.config.action_mailer.default_url_options[:host]
      @galleries_path = IshManager::Engine.routes.url_helpers.galleries_path
      @gallery_path   = IshManager::Engine.routes.url_helpers.gallery_path(@gallery.galleryname)
      mail( :to => '314658@gmail.com',
            :bcc => profiles.map { |p| p.email },
            :subject => 'You got new shared galleries on pi manager' ).deliver
    end

  end
end
