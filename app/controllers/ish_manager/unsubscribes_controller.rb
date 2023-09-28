
class ::IshManager::UnsubscribesController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::EmailUnsubscribe
    @unsubscribes = Ish::EmailUnsubscribe.all
  end

end

