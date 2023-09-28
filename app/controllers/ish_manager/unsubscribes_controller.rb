
class ::IshManager::UnsubscribesController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::EmailUnsubscribe
    @unsubscribes = Ish::EmailUnsubscribe.all
    lead_ids = @unsubscribes.map(&:lead_id).compact
    @leads_h = Lead.find_to_h( lead_ids )
    puts! @leads_h, 'ddz'
  end

end

