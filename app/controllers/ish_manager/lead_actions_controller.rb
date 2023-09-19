
class IshManager::LeadActionsController < IshManager::ApplicationController

  def index
    authorize! :index, Office::LeadAction
    @lead_actions = Office::LeadAction.all
  end

end

