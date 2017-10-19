module IshManager
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'

    def welcome
      @var = :value
      mail( :to => 'piousbox@gmail.com', :subject => 'Abba, welcome!' )
    end

  end
end
