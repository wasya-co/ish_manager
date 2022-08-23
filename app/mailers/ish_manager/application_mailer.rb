
module IshManager
  class ApplicationMailer < ActionMailer::Base
    default from: '314658@gmail.com'
    layout 'mailer'

    def shared_galleries profiles, gallery
      return if profiles.count == 0
      @gallery        = gallery
      @domain         = Rails.application.config.action_mailer.default_url_options[:host]
      @galleries_path = IshManager::Engine.routes.url_helpers.galleries_path
      @gallery_path   = IshManager::Engine.routes.url_helpers.gallery_path(@gallery.slug)
      mail( :to => '314658@gmail.com',
            :bcc => profiles.map { |p| p.email },
            :subject => 'You got new shared galleries on pi manager' ).deliver
    end

    def option_alert option
      @option = option
      mail( :to => option.profile.email, :subject => "IshManager Option Alert :: #{option.ticker}" ).deliver
    end

    def stock_alert stock
      @stock = stock
      mail( :to => stock.profile.email, :subject => "IshManager Stock Alert :: #{stock.ticker}" ).deliver
    end

    def test_email s=''
      puts! s, "#test_email - delivering"
      mail( to: 'piousbox@gmail.com', subject: "Test #{s} :: #{DateTime.now.strftime("%Y-%m-%d %l:%M:%S %P")}" )
    end

  end
end
