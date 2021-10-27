
class IshManager::AllyController < IshManager::ApplicationController

  def home
    authorize! :ally_home, IshManager::Ability
  end

end
