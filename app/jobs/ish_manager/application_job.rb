
class IshManager::ApplicationJob < ActiveJob::Base

  include Sidekiq::Job

end

