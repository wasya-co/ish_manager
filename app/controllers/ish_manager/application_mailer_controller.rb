
class IshManager::ApplicationMailerController < ActionController::Base
  helper IshManager::ApplicationHelper

  def url_options
    {
      host: 'test-host',
    }
  end
end
