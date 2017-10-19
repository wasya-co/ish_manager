
class IshManager::AllyController < IshManager::ApplicationController

  def home
    authorize! :home_ally, IshManager::Ability
    render 'home', :layout => 'ish_manager/application_no_materialize'
  end

end



