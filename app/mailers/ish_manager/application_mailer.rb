
module IshManager
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'

    def welcome
      @var = :value
      mail( :to => 'piousbox@gmail.com', :subject => 'Abba, welcome!' ).deliver
    end

    def stock_alert stock
      @stock = stock
      mail( :to => stock.profile.email, :subject => 'IshManager Stock Alert' ).deliver
    end

  end
end
