
class IshManager::TestEmailJob < ApplicationJob
  include Sidekiq::Worker
  Sidekiq_options queue: "mailers"

  def perform
    puts! 'performing test job'
    ::IshManager::ApplicationMailer.test_email.deliver_later
  end

end
