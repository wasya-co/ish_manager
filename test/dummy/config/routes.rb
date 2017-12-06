Rails.application.routes.draw do
  root :to => 'application#home'

  mount IshManager::Engine => "/ish_manager"

  devise_for :users, :skip => [ :registrations ]
  
  get 'status', :to => 'application#home', :as => :new_user_session

end
