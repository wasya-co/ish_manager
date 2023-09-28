
class IshManager::LeadActionsController < IshManager::ApplicationController

  def edit
    @lead_action = Office::LeadAction.find params[:id]
    @olats_list = OLAT.list
    @leads_list = Lead.list
    authorize! :edit, @lead_action
  end

  def index
    authorize! :index, Office::LeadAction
    @lead_action_templates = Office::LeadActionTemplate.all
    @lead_actions = Office::LeadAction.all
  end

end

