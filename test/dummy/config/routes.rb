Rails.application.routes.draw do
  mount IshManager::Engine => "/ish_manager"

  # @TODO: OMG this works
  get 'trash', :to => 'application#home', :as => :new_user_session

end
