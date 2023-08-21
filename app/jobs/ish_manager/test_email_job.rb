
class IshManager::TestEmailJob
  include Sidekiq::Job
  queue_as :mailers

  def perform
    puts! 'performing test job'
    ::IshManager::ApplicationMailer.test_email.deliver_later
  end

end


