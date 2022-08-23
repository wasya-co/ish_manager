
class IshManager::UnsubscribesController < IshManager::ApplicationController

  layout false

  # alphabetized : )

  def new
    @unsubscribe = Ish::Unsubscribe.new
    authorize! :new, @unsubscribe
  end

  def create
    authorize! :open_permission, IshManager::Ability
  end

end
